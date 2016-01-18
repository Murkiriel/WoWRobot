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

	local message = config.about_text .. '\n\nSou um bot baseado no otouto v'..version..' que está licenciado sob a GPLv2. Confira em github.com/Murkiriel/WoWRobot'

	local bemdat = load_data('data/bemvindo.json')
	local bemvindo = bemdat[msg.chat.id_str]

	if msg.new_chat_participant and msg.new_chat_participant.id == bot.id then
		sendMessage(msg.chat.id, message, true, msg.message_id, true)
	elseif msg.new_chat_participant and bemvindo ~= false then

		if bemvindo == nil or bemvindo == true then
			local msg_regras = ''
			local regdat = load_data('data/regras.json')

			if regdat[msg.chat.id_str] then
				msg_regras = '\n\nUse /regras'
			end

			message = 'Olá *' .. msg.new_chat_participant.first_name .. '*!\nSeja bem-vindo(a) ao Grupo _' .. msg.chat.title .. '_ ;]' .. msg_regras
		else
			bemvindo = string.gsub(bemvindo, '$nome', msg.new_chat_participant.first_name)
			bemvindo = string.gsub(bemvindo, '$grupo', msg.chat.title)

			if not msg.new_chat_participant.username then
				bemvindo = string.gsub(bemvindo, '$usuario', msg.new_chat_participant.first_name)
			else
				bemvindo = string.gsub(bemvindo, '$usuario', '@' .. msg.new_chat_participant.username)
			end

			message = bemvindo
		end

		sendMessage(msg.chat.id, message, true, msg.message_id, true)
	elseif string.match(msg.text_lower, '^/sobre[@'..bot.username..']*') then
		sendMessage(msg.chat.id, message, true, msg.message_id, true)
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
