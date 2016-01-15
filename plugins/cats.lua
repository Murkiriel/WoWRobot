if not config.thecatapi_key then
	print('Valor de configuração ausente: thecatapi_key.')
	print('cats.lua será habilitado, mas há mais recursos com uma chave')
end

local command_id = '7'
local command = 'gatos'

local doc = [[
	/gatos

Retorna um gato!
]]

local triggers = {
	'^/gatos[@'..bot.username..']*'
}

local action = function(msg)

	sendChatAction(msg.chat.id, 'upload_photo')

	local url = 'http://thecatapi.com/api/images/get?format=html&type=jpg'
	if config.thecatapi_key then
		url = url .. '&api_key=' .. config.thecatapi_key
	end

	local str, res = HTTP.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	str = str:match('<img src="(.*)">')

	strnome = str:gsub('/', '_')

	download_file(str, strnome)

	sendPhoto(msg.chat.id, config.tmp .. strnome, '😻',msg.message_id)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
