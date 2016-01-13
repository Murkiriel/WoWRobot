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
	local bemvindo = ''
	local bemvindo_mensagem = ''

	if not bemdat[msg.chat.id_str] then
		local bemvindo = true
	else
		local bemvindo = bemdat[msg.chat.id_str]
	end

	-- # ADORARIA SUGESTÕES NESTA PARTE :D
	if not bemdat['mensagem'] then
	elseif not bemdat['mensagem'][msg.chat.id_str] then
	else
		bemvindo_mensagem = bemdat['mensagem'][msg.chat.id_str]
	end

	if msg.new_chat_participant and msg.new_chat_participant.id == bot.id then
		sendMessage(msg.chat.id, message, true)
		return
	elseif msg.new_chat_participant and bemvindo ~= false then

		if bemvindo_mensagem == '' then
			local msg_regras = ''
			local regdat = load_data('data/regras.json')

			if regdat[msg.chat.id_str] then
				msg_regras = '\n\nUse /regras'
			end

			message = 'Olá ' .. msg.new_chat_participant.first_name .. '!\nSeja bem-vindo(a) ao Grupo ' .. msg.chat.title .. ' ;]' .. msg_regras
		else
			bemvindo_mensagem = string.gsub(bemvindo_mensagem, '$nome', msg.new_chat_participant.first_name)
			bemvindo_mensagem = string.gsub(bemvindo_mensagem, '$grupo', msg.chat.title)

			if not msg.new_chat_participant.username then
				bemvindo_mensagem = string.gsub(bemvindo_mensagem, '$usuario', msg.new_chat_participant.first_name)
			else
				bemvindo_mensagem = string.gsub(bemvindo_mensagem, '$usuario', '@' .. msg.new_chat_participant.username)
			end

			message = bemvindo_mensagem
		end

		sendMessage(msg.chat.id, message, true)
		return
	elseif string.match(msg.text_lower, '^/sobre[@'..bot.username..']*') then
		sendReply(msg, message)
		return
	end

	-- # ISSO RESOLVEU PARA MIM PROBLEMAS COM MENSAGENS DE SERVIÇO
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
