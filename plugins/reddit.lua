local command_id = '17'
local command = 'reddit'

local doc = [[
	/reddit pesquisa

Retorna 4 (caso seja grupo) ou 8 (caso seja privado) principais posts sobre a consulta dada ou a partir da primeira página
]]

local triggers = {
	'^/reddit[@'..bot.username..']*'
}

local action = function(msg)

	msg.text_lower = msg.text_lower:gsub('/r/', '/r r/')
	local input = msg.text_lower:input()
	local url

	local limit = 4
	if msg.chat.id == msg.from.id then
		limit = 8
	end

	if input then
		if input:match('^r/') then
			url = 'http://www.reddit.com/' .. input .. '/.json?limit=' .. limit
		else
			url = 'http://www.reddit.com/search.json?q=' .. input .. '&limit=' .. limit
		end
	else
		url = 'http://www.reddit.com/.json?limit=' .. limit
	end

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)
	if #jdat.data.children == 0 then
		sendReply(msg, config.errors.results)
		return
	end

	local message = ''
	for i,v in ipairs(jdat.data.children) do
		local long_url = '\n'
		if not v.data.is_self then
			long_url = '\n' .. v.data.url .. '\n'
		end
		local short_url = 'redd.it/' .. v.data.id
		message = message .. i .. ') '

		if v.data.over_18 then
			message = message .. '[NSFW] '
		end

		message = message .. v.data.title .. '\n' .. short_url .. '\n\n'

	end

	sendReply(msg, message)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
