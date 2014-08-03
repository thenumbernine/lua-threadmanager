--[[
thread manager for whoever
threads are added through add and updated through update
--]]

require 'ext.table'
local class = require 'ext.class'

local ThreadManager = class()

function ThreadManager:init()
	self.threads = table()
	self.mainLoopCalls = table()
end

function ThreadManager:add(f, ...)
	local thread = coroutine.create(f)
	self.threads:insert(thread)
	local res, err = coroutine.resume(thread, ...)	-- initial arguments
	if not res then
		-- don't remove it just yet -- it'll be gathered on next loop cycle
		io.stderr:write(tostring(err)..'\n')
		io.stderr:write(tostring(debug.traceback(thread))..'\n')
	end
	return thread
end

function ThreadManager:addMainLoopCall(f, ...)
	self.mainLoopCalls:insert{f, ...}
end

function ThreadManager:update()
	-- update threads
	local i = 1
	while i <= #self.threads do
		local thread = self.threads[i]
		if coroutine.status(thread) == 'dead' then
			self.threads:remove(i)
		else
			local res, err = coroutine.resume(thread)
			if not res then
				io.stderr:write(tostring(err)..'\n')
				io.stderr:write(tostring(debug.traceback(thread))..'\n')
				self.threads:remove(i)
			end
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

