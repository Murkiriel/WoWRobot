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

	os.execute('wget --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" -c -O ' .. strnome .. ' ' .. str)

	sendPhoto(msg.chat.id, config.root .. strnome, '😻',msg.message_id)

	os.execute('rm ' .. strnome)
end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
