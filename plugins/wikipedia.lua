local command_id = '18'
local command = 'wikipedia'

local doc = [[
	/wikipedia <pesquisa>

Retorna um artigo da Wikipedia
]]

local triggers = {
	'^/w[ikipedia][@'..bot.username..']*',
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

	local gurl = 'https://ajax.googleapis.com/ajax/services/search/web?v=1.0&rsz=1&q=site:wikipedia.org%20'
	--local wurl = 'https://en.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exchars=4000&exsectionformat=plain&titles='
	local wurl = 'https://pt.wikipedia.org/w/api.php?action=query&prop=extracts&format=json&exchars=4000&exsectionformat=plain&explaintext=&redirects=&titles='
	local jstr, res = HTTPS.request(gurl .. URL.escape(input))
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)
	if not jdat.responseData.results[1] then
		sendReply(msg, config.errors.results)
		return
	end

	local url = jdat.responseData.results[1].url
	local title = jdat.responseData.results[1].titleNoFormatting:gsub(' %- Wikipedia, the free encyclopedia', '')

	jstr, res = HTTPS.request(wurl .. URL.escape(title))
	if res ~= 200 then
		sendReply(msg, config.error.connection)
		return
	end

	local text = JSON.decode(jstr).query.pages
	for k,v in pairs(text) do
		text = v.extract
		break -- Sério, há provavelmente uma solução mais elegante
	end
	if not text then
		sendReply(msg, config.errors.results)
		return
	end

	text = text:gsub('</?.->', '')
	local l = text:find('\n')
	if l then
		text = text:sub(1, l-1)
	end
	url = url:gsub('https://en.', 'https://pt.')
	text = 'Título: [' .. title .. '](' .. url ..')\n\n' .. text

	sendMessage(msg.chat.id, text, true, msg.message_id, true)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
