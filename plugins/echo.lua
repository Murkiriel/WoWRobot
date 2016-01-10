local command_id = '5'
local command = 'diga'

local doc = [[
	/diga <texto>

Repita a sequência do texto!
]]

local triggers = {
	'^/diga[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()

	if input then
		sendReply(msg, latcyr(input))
	else
		sendReply(msg, doc)
	end

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
