local command_id = '11'
local command = 'id'

local doc = [[
	/id

Obter informações sobre mim
]]

local triggers = {
	'^/id[@'..bot.username..']*'
}

local action = function(msg)

	if msg.reply_to_message then
		msg = msg.reply_to_message
	end

	local from_name = 'Seu nome é ' .. msg.from.first_name
	if msg.from.last_name then
		from_name = from_name .. ' ' .. msg.from.last_name
	end

	local nicks = load_data('data/nicknames.json')
	if nicks[msg.from.id_str] then
		from_name = from_name .. ', apelidado de ' .. nicks[msg.from.id_str]
	end

	if msg.from.username then
		from_name = from_name .. '\nUsuário: @' .. msg.from.username
	end
	from_name = from_name .. '\nID: ' .. msg.from.id

	local to_name
	local message
	if msg.chat.title then
		to_name = msg.chat.title .. ' (ID: -' .. math.abs(msg.chat.id) .. ')'
		message = from_name .. '\n\nVocê está no Grupo ' .. to_name
	else
		message = from_name .. '\n\nVocê está no meu privado!'
	end

	sendReply(msg, message)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
