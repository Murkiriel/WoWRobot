-- # Requer ranking_data.lua ativado

local command_id = '16'
local command = 'ranking'

local doc = [[
	/ranking

Ranking de mensagens
]]


local triggers = {
	'^/ranking[@'..bot.username..']*'
}

local commands = {

	['^/ranking[@'..bot.username..']*'] = function(msg)

		local rkgdat = load_data('data/ranking/' .. msg.chat.id_str .. '.json')

		local vetor1 = {}
		local vetor2 = {}
		local cont1 = 0
		local cont2 = 0

		for i in pairs(rkgdat) do

			for j, k in pairs(rkgdat[i]) do

				if j == 'mensagens' then
					vetor1[cont1] = k
					cont1 = cont1 + 1
				end

				if k == 'mensagens' then
					vetor1[cont1] = j
					cont1 = cont1 + 1
				end

			end

			for l, m in pairs(rkgdat[i]) do

				if l == 'primeiro_nome' then
					vetor2[cont2] = m
					cont2 = cont2 + 1
				end

				if m == 'primeiro_nome' then
					vetor2[cont2] = l
					cont2 = cont2 + 1
				end

			end

		end

		local vetor3 = {}
		for i=0, cont2-1 do
			vetor3[vetor2[i]] = vetor1[i]
		end

		local i = 0
		local message = 'Ranking de Mensagens\n\n'
		for k,v in spairs(vetor3, function(t,a,b) return t[b] < t[a] end) do
			i = i + 1
			message = message .. v .. ' => ' .. k .. '\n'

			if i == 50 then
				return message
			end
		end

		return message

	end

}

local action = function(msg)

	for k,v in pairs(commands) do
		if string.match(msg.text_lower, k) then
			local output = v(msg)
			if output == true then
				return true
			elseif output then
				sendReply(msg, output)
			end
			return
		end
	end

end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command_id = command_id,
	command = command
}
