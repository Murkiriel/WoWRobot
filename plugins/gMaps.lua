local command_id = '13'
local command = 'localizar'

local doc = [[
	/localizar <lugar>

Retorna uma localização do Google Maps
]]

triggers = {
	'^/loc[alizar]*[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendReply(msg, doc)
			return
		end
	end

	local coords = get_coords(input)
	if type(coords) == 'string' then
		sendReply(msg, coords)
		return
	end

	sendLocation(msg.chat.id, coords.lat, coords.lon, msg.message_id)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
