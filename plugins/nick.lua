local command_id = '2'
local command = 'apelido'

local doc = [[
	/apelido <texto>

Defina o seu apelido. Use "/id" para ver o seu apelido e "/apelido -" para excluí-lo
]]

local triggers = {
	'^/apelido[@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()
	if not input then
		sendReply(msg, doc)
		return true
	end

	if string.len(input) > 32 then
		sendReply(msg, 'O limite de caracteres para o apelido é de 32')
		return true
	end

	nicks = load_data('data/nicknames.json')

	if input == '-' then
		nicks[msg.from.id_str] = nil
		sendReply(msg, 'Seu apelido foi apagado')
	else
		nicks[msg.from.id_str] = input
		sendReply(msg, 'Seu apelido foi definido para "' .. input .. '"')
	end

	save_data('data/nicknames.json', nicks)
	return true

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
