-- utilities.lua
-- Funções compartilhadas entre plugins

function get_word(s, i) -- Obter a palavra indexada em uma string

	s = s or ''
	i = i or 1

	local t = {}
	for w in s:gmatch('%g+') do
		table.insert(t, w)
	end

	return t[i] or false

end

function string:input() -- Retorna a string após o primeiro espaço
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

function latcyr(str) -- Substitui letras com seus correspondentes caracteres Cyrillic
	for k,v in pairs(lc_list) do
		str = string.gsub(str, k, v)
	end
	return str
end

function load_data(filename) -- Carrega um arquivo JSON como uma tabela

	local f = io.open(filename)
	if not f then
		return {}
	end
	local s = f:read('*all')
	f:close()
	local data = JSON.decode(s)

	return data

end

function save_data(filename, data) -- Salva uma tabela para um arquivo JSON

	local s = JSON.encode(data)
	local f = io.open(filename, 'w')
	f:write(s)
	f:close()

end

 -- Obtém coordenadas para um local. Usado por gMaps.lua, time.lua, weather.lua
function get_coords(input)

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
