 -- Na verdade o mais simples plugin desde sempre!

local command_id = '14'
local command = 'ping'

local doc = [[
	/ping

Pong!
]]

local triggers = {
	'^/ping[@'..bot.username..']*'
}

local action = function(msg)
	sendReply(msg, 'Pong!')
end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
