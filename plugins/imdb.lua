local command_id = '12'
local command = 'imdb'

local doc = [[
	/imdb  <filme>

Retorna uma pesquisa IMDB
]]

local triggers = {
	'^/imdb[@'..bot.username..']*'
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

	local url = 'http://www.omdbapi.com/?t=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		sendReply(msg, config.errors.connection)
		return
	end

	local jdat = JSON.decode(jstr)

	if jdat.Response ~= 'True' then
		sendReply(msg, config.errors.results)
		return
	end

	local message = 'Nome: ' .. jdat.Title ..' ('.. jdat.Year ..')\n'
	message = message .. 'Avaliação: ' .. jdat.imdbRating ..'\nGênero: '.. jdat.Genre ..'\n'
	message = message .. jdat.Runtime ..' | ' .. jdat.Plot .. '\n'
	message = message .. 'Link: http://imdb.com/title/' .. jdat.imdbID

	sendReply(msg, message)

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
