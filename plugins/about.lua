local command_id = '1'
local command = 'sobre'

local doc = [[
	/sobre

Obter informações sobre o bot
]]

local triggers = {
	''
}

local action = function(msg)

	local message = config.about_text .. '@WoWRobot ' .. version_wow .. '\n\nConfira como um bot telegram API pode ser tão WoW!!!\n\nSou um bot baseado no otouto v'..version..' que está licenciado sob a GPLv2. Confira em topkecleon.github.io/otouto'

	local moddat = load_data('moderation.json')

	bemvindo = moddat['bemvindo-' .. msg.chat.id_str]

	if msg.new_chat_participant and msg.new_chat_participant.id == bot.id then
		sendMessage(msg.chat.id, message)
		return
	elseif msg.new_chat_participant and bemvindo ~= false then
		local message = 'Olá ' .. msg.new_chat_participant.first_name .. '!\nSeja bem-vindo(a) ao Grupo ' .. msg.chat.title .. ' ;]\n\nUse /regras'
		sendMessage(msg.chat.id, message)
	elseif string.match(msg.text_lower, '^/sobre[@'..bot.username..']*') then
		sendReply(msg, message)
		return
	end

	if msg.new_chat_participant or msg.left_chat_participant then
		bot_init()
		return
	end

	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
