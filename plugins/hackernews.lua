local command_id = '10'
local command = 'hackernews'

local doc = [[
	/hackernews

Retorna 6 (caso seja grupo) ou 8 (caso seja privado) as principais notícias do Hacker News.
]]

local triggers = {
	'^/hackernews[@'..bot.username..']*',
	'^/hn[@'..bot.username..']*'
}

local action = function(msg)

	sendChatAction(msg.chat.id, 'typing')

	local jstr, res = HTTPS.request('https://hacker-news.firebaseio.com/v0/topstories.json')
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)

	local res_count = 6
	if msg.chat.id == msg.from.id then
		res_count = 8
	end

	local message = ''
	for i = 1, res_count do
		local res_url = 'https://hacker-news.firebaseio.com/v0/item/' .. jdat[i] .. '.json'
		jstr, res = HTTPS.request(res_url)
		if res ~= 200 then
			sendReply(msg, config.errors.connection)
			return
		end
		local res_jdat = JSON.decode(jstr)
		message = message .. i .. ') [' .. res_jdat.title .. '](' .. res_jdat.url .. ')\n\n'
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
