-- utilities.lua
-- Funções compartilhadas entre plugins

HTTP = require('socket.http')  
HTTPS = require('ssl.https')  
JSON = require('dkjson')  

 -- Obter a palavra indexada em uma string
get_word = function(s, i) 

	s = s or ''
	i = i or 1

	local t = {}
	for w in s:gmatch('%g+') do
		table.insert(t, w)
	end

	return t[i] or false

end

 -- Retorna a string após o primeiro espaço
function string:input() 
	if not self:find(' ') then
		return false
	end
	return self:sub(self:find(' ')+1)
end

 -- Eu juro, eu copiei isso de PIL, não do Yago! :)
function string:trim() -- Apara espaços em branco a partir de uma string
	local s = self:gsub('^%s*(.-)%s*$', '%1')
	return s
end

local lc_list = {
-- Latin = 'Cyrillic'
	['A'] = 'А',
	['B'] = 'В',
	['C'] = 'С',
	['E'] = 'Е',
	['I'] = 'І',
	['J'] = 'Ј',
	['K'] = 'К',
	['M'] = 'М',
	['H'] = 'Н',
	['O'] = 'О',
	['P'] = 'Р',
	['S'] = 'Ѕ',
	['T'] = 'Т',
	['X'] = 'Х',
	['Y'] = 'Ү',
	['a'] = 'а',
	['c'] = 'с',
	['e'] = 'е',
	['i'] = 'і',
	['j'] = 'ј',
	['o'] = 'о',
	['s'] = 'ѕ',
	['x'] = 'х',
	['y'] = 'у',
	['!'] = 'ǃ'
}

 -- Substitui letras com seus correspondentes caracteres Cyrillic
latcyr = function(str)
	for k,v in pairs(lc_list) do
		str = string.gsub(str, k, v)
	end
	return str
end

  -- Carrega um arquivo JSON como uma tabela
load_data = function(filename)

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

 -- Salva uma tabela para um arquivo JSON
save_data = function(filename, data)

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

 -- Obtém coordenadas para um local. Usado por gMaps.lua, time.lua, weather.lua
get_coords = function(input)

	local url = 'http://maps.googleapis.com/maps/api/geocode/json?address=' .. URL.escape(input)

	local jstr, res = HTTP.request(url)
	if res ~= 200 then
		return config.errors.connection
	end

	local jdat = JSON.decode(jstr)
	if jdat.status == 'ZERO_RESULTS' then
		return config.errors.results
	end

	return {
		lat = jdat.results[1].geometry.location.lat,
		lon = jdat.results[1].geometry.location.lng
	}

end

 -- Obter o número de valores em uma tabela de chave/valor
table_size = function(tab)

	local i = 0
	for k,v in pairs(tab) do
		i = i + 1
	end
	return i

end

resolve_username = function(target)
 -- Se $target é um nome de usuário conhecido, retorna associada ID
 -- Se $target é um nome de usuário desconhecido, retorna nil
 -- Se $target é um número, retorna este número
 -- Caso contrário, retorna false

	local input = tostring(target):lower()
	if input:match('^@') then
		local uname = input:gsub('^@', '')
		return usernames[uname]
	else
		return tonumber(target) or false
	end

end

handle_exception = function(err, message)

	local output = '\n[' .. os.date('%F %T', os.time()) .. ']\n' .. bot.username .. ': ' .. err .. '\n' .. message .. '\n'

	if config.log_chat then
		output = '```' .. output .. '```'
		sendMessage(config.log_chat, output, true, nil, true)
	else
		print(output)
	end

end

 -- Okay, este que eu realmente fiz uma cópia do yagop
 -- https://github.com/yagop/telegram-bot/blob/master/bot/utils.lua
download_file = function(url, filename)

	local respbody = {}
	local options = {
		url = url,
		sink = ltn12.sink.table(respbody),
		redirect = true
	}

	local response = nil

	if url:match('^https') then
		options.redirect = false
		response = { HTTPS.request(options) }
	else
		response = { HTTP.request(options) }
	end

	local code = response[2]
	local headers = response[3]
	local status = response[4]

	if code ~= 200 then return false end

	filename = filename or os.time()

	local file_path = '/tmp/'..filename

	file = io.open(file_path, 'w+')
	file:write(table.concat(respbody))
	file:close()

	return file_path

end

spairs = function(t, order)
	-- Recolhe as chaves
	local keys = {}
	for k in pairs(t) do keys[#keys+1] = k end

	-- Se a função informar a ordem, classificar por ele passando a tabela e as chaves a, b,
	-- caso contrário, apenas ordenar as chave
	if order then
		table.sort(keys, function(a,b) return order(t, a, b) end)
	else
		table.sort(keys)
	end

	-- Retornar a função iterator
	local i = 0
	return function()
		i = i + 1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end
