local command_id = '8'
local command = 'google'

local doc = [[
	/google <texto>

Retorna 6 (caso seja grupo) ou 8 (caso seja privado) resultos do Google. Safe search é habilitada por padrão, use "/googlex" para desativá-lo
]]

local triggers = {
	'^/g[oogle]*[ooglex][@'..bot.username..']*'
}

local action = function(msg)

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message and msg.reply_to_message.text then
			input = msg.reply_to_message.text
		else
			sendReply(msg, doc)
			return
		end
	end

	local url = 'https://ajax.googleapis.com/ajax/services/search/web?v=1.0'

	if msg.from.id == msg.chat.id then
		url = url .. '&rsz=8'
	else
		url = url .. '&rsz=6'
	end

	if not string.match(msg.text, '^/g[oogle]*ooglex') then
		url = url .. '&safe=active'
	end

	url = url .. '&q=' .. URL.escape(input)

	local jstr, res = HTTPS.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)
	if #jdat.responseData.results < 1 then
		sendReply(msg, config.errors.results)
		return
	end

	local message = '*Resultados para* _' .. input .. '_*:*\n\n'
	for i,v in ipairs(jdat.responseData.results) do
		jdat.responseData.results[i].titleNoFormatting = jdat.responseData.results[i].titleNoFormatting:gsub(']', '')
		message = message .. i .. ') [' .. jdat.responseData.results[i].titleNoFormatting .. ']' .. '(' .. jdat.responseData.results[i].unescapedUrl .. ')' .. '\n\n'
	end

	sendMessage(msg.chat.id, message, true, msg.message_id, true)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
