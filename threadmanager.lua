--[[
thread manager for whoever
threads are added through add and updated through update
--]]

local table = require 'ext.table'
local class = require 'ext.class'

ThreadManager = class()

function ThreadManager:init()
	self.threads = table()
	self.mainLoopCalls = table()
end

function ThreadManager:add(f, ...)
	local th = coroutine.create(f)
	self.threads:insert(th)
	local res, err = coroutine.resume(th, ...)	-- initial arguments
	if not res then
		-- don't remove it just yet -- it'll be gathered on next loop cycle
		print(err)
		print(debug.traceback(thread))
	end
	return th
end

function ThreadManager:addMainLoopCall(f, ...)
	self.mainLoopCalls:insert{f, ...}
end

function ThreadManager:updateThread(thread)
	if coroutine.status(thread) == 'dead' then
		return false
	else
		local res, err = coroutine.resume(thread)
		if not res then
			print(err)
			print(debug.traceback(thread))
			return false
		end
	end
	return true
end

function ThreadManager:update()
	-- update threads
	local i = 1
	while i <= #self.threads do
		local thread = self.threads[i]
		if not self:updateThread(thread) then
			self.threads:remove(i)
		else
			i = i + 1
		end
	end
	
	-- update main loop calls
	if #self.mainLoopCalls > 0 then
		local lastMainLoopCalls = self.mainLoopCalls
		self.mainLoopCalls = table()	-- reset, in case someone wants to add to this mid-callback
		
		for _,call in ipairs(lastMainLoopCalls) do
			local f = table.remove(call, 1)
			f(unpack(call))
		end		
	end
end

return ThreadManager
