-- Colocar esta absolutamente no final, mesmo após greetings.lua

local triggers = {
	''
}

local action = function(msg)

	msg.text = string.lower(msg.text)
	palavrachave, j = string.find(msg.text, 'wow')

	if msg.text == '' then return end

	-- Isso é estranho, mas se você tiver uma maneira melhor, por favor, compartilhe
	if msg.text_lower:match('^' .. bot.first_name) then
	elseif msg.text_lower:match('^@' .. bot.username) then
	elseif msg.text:match('^/') then return true
	elseif msg.reply_to_message and msg.reply_to_message.from.id == bot.id then
	elseif msg.from.id == msg.chat.id then
	elseif palavrachave ~= nil then
	else
		return true
	end

	sendChatAction(msg.chat.id, 'typing')

	local input = msg.text_lower
	input = input:gsub('@' .. bot.username, 'ed')
	input = input:gsub('wow', 'ed')

	local url = 'http://www.ed.conpet.gov.br/mod_perl/bot_gateway.cgi?server=0.0.0.0:8085&pure=1&js=1&msg=' .. URL.escape(input)

	local t, res = HTTP.request(url)

	if res ~= 200 then
		sendReply(msg, config.errors.chatter_response)
		return
	end

	local cleaner = {
		{ "&amp;", "&" },
		{ "&#151;", "-" },
		{ "&#146;", "'" },
		{ "&#147;", "\"" },
		{ "&#148;", "\"" },
		{ "&#150;", "-" },
		{ "&#160;", " " },
		{ "<br ?/?>", "\n" },
		{ "</p>", "\n" },
		{ "(%b<>)", "" },
		{ "\r", "\n" },
		{ "[\n\n]+", "\n" },
		{ "^\n*", "" },
		{ "\n*$", "" },
	}

	for i=1, #cleaner do
		local cleans = cleaner[i]
		t = string.gsub(t, cleans[1], cleans[2])
	end

	t=t:gsub('<a.->(.-)</a>','')
	t=t:gsub('<a href="#','')

	local resposta = t

	-- # ÍNICIO DO QUE VOCÊ DEVE MODIFICAR
	--[[var1, j = string.find(resposta, 'Kyr')  -- # Procura certas palavras-chave na resposta
	var2, j = string.find(resposta, 'CONPET')  -- # Procura certas palavras-chave na resposta

	if var1 ~= nil or var2 ~= nil then  -- # Se a palavra-chave existir faça isso abaixo
		resposta = 'Nem sei sobre isso :P' -- # Troca a resposta pelo que você quiser
	end]]

	resposta = string.gsub(resposta, 'Ed ', 'WoW ') -- # Troca o nome 'Ed ' por 'WoW'. Altere 'WoW' para o que desejar
	resposta = string.gsub(resposta, 'Ed.', 'WoW.') -- # Troca o nome 'Ed ' por 'WoW'. Altere 'WoW' para o que desejar
	-- # FIM DO QUE VOCÊ DEVE MODIFICAR

	local message = resposta

	if message:match('^I HAVE NO RESPONSE.') then
		message = config.errors.chatter_response
	end

	-- Vamos limpar a resposta um pouco (mais). Capitalização e pontuação
	local filter = {
		['%aimi?%aimi?'] = bot.first_name,
		['^%s*(.-)%s*$'] = '%1',
		['^%l'] = string.upper,
		['USER'] = msg.from.first_name
	}

	for k,v in pairs(filter) do
		message = string.gsub(message, k, v)
	end

	if not string.match(message, '%p$') then
		message = message .. '.'
	end

	sendReply(msg, message)

end

return {
	action = action,
	triggers = triggers,
	doc = doc
}
