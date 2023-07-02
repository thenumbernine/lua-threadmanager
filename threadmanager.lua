--[[
thread manager for whoever
threads are added through add and updated through update
--]]

local table = require 'ext.table'
local class = require 'ext.class'
local coroutine = require 'ext.coroutine'

local ThreadManager = class()

function ThreadManager:init()
	self.threads = table()
	self.mainLoopCalls = table()
end

function ThreadManager:add(f, ...)
	local th = coroutine.create(f)
	self.threads:insert(th)
	local res, err = coroutine.resume(th, ...)	-- initial arguments
	-- TODO this is the same as 'safehandle' within 'assertresume'
	-- it is basically 'assertresume' except that has an extra status check
	if not res then
		-- don't remove it just yet -- it'll be gathered on next loop cycle
		print(err)
		print(debug.traceback(th))
	end
	return th
end

-- first argument is the function, rest are the call arguments
function ThreadManager:addMainLoopCall(...)
	self.mainLoopCalls:insert(table.pack(...))
	return #self.mainLoopCalls
end

function ThreadManager:update()
	-- update threads
	local i = 1
	while i <= #self.threads do
		local thread = self.threads[i]
		local result, err = coroutine.assertresume(thread)
		if not result then
			self.threads:remove(i)
		else
			i = i + 1
		end
	end

	-- update main loop calls
	local n = #self.mainLoopCalls
	if n > 0 then
		for i=1,n do
			local call = self.mainLoopCalls[i]
			call[1](call:unpack(2, call.n))
		end
		for i=n,1,-1 do
			self.mainLoopCalls:remove(i)
		end
	end
end

return ThreadManager
