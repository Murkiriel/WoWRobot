 -- Este plugin permite que o administrador barre usuários que não serão capazes de
 -- usar o bot. Este plugin deve estar no topo da sua lista de plug-in na configuração

local triggers = {
	''
}

 local action = function(msg)

	local blacklist = load_data('data/blacklist.json')

	if blacklist[msg.from.id_str] then
		return -- Fim se o remetente está na lista negra.
	end

	if not string.match(msg.text_lower, '^/listanegra') then
		return true
	end

	if msg.from.id ~= config.admin then
		return -- Fim se o usuário não é admin
	end

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message then
			input = tostring(msg.reply_to_message.from.id)
		else
			sendReply(msg, 'Você deve usar este comando através de menções ou especificando um ID de usuário')
			return
		end
	end

	if blacklist[input] then
		blacklist[input] = nil
		sendReply(msg, input .. ' foi removido da lista negra')
	else
		blacklist[input] = true
		sendReply(msg, input .. ' foi adicionado à lista negra')
	end

	save_data('data/blacklist.json', blacklist)

 end

 return {
	action = action,
	triggers = triggers
}
