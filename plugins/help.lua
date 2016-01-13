 -- Este plugin deve ir no final de sua lista de plugin no
 -- config.lua, mas não depois greetings.lua

local help_text = '*Comandos disponíveis:*\n'

for i,v in ipairs(plugins) do
	if v.command_id then
		help_text = help_text .. '\n' .. v.command_id:gsub('%[', '\\[') .. ' - /' .. v.command:gsub('%[', '\\[')
	end
end

help_text = help_text .. '\n\n/ajuda <número>'

local triggers = {
	'^/start[@'..bot.username..']*',
	'^/iniciar[@'..bot.username..']*',
	'^/help[@'..bot.username..']*',
	'^/ajuda[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text_lower:input()

	-- As tentativas de enviar a mensagem de ajuda no privado
	-- Se a mensagem é de um grupo, ele diz ao grupo se a mensagem no privado foi bem sucedida
	if not input then
		local res = sendMessage(msg.chat.id, help_text, true, msg.message_id, true)
		--[[if not res then
			sendReply(msg, 'Por favor mande uma mensagem no meu privado para uma lista de comandos')
		elseif msg.chat.type ~= 'private' then
			sendReply(msg, 'Enviei as informações solicitadas em uma mensagem privada')
		end]]
		return
	end

	for i, v in ipairs(plugins) do
		if v.command_id and get_word(v.command_id, 1) == input and v.doc then
			local output = v.doc
			sendMessage(msg.chat.id, output, true, msg.message_id, true)
			return
		end
	end

	sendMessage(msg.chat.id, help_text, true, msg.message_id, true)

end

return {
	action = action,
	triggers = triggers
}
