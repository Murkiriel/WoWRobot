local triggers = {
	'^/recarregar[@'..bot.username..']*',
	'^/parar[@'..bot.username..']*'
}

local action = function(msg)

	if msg.from.id ~= config.admin then
		sendReply(msg, 'Você não tem poderes para isso :[')
		return
	end

	if msg.text:match('^/recarregar') then
		bot_init()
		sendReply(msg, 'Bot recarregado!')
	elseif msg.text:match('^/parar') then
		is_started = false
		sendReply(msg, 'Bot parado!')
	end

end

return {
	action = action,
	triggers = triggers
}
