-- # Requer que o bot tenha acesso à todas as mensagens
-- # Verifique no @BotFather

local triggers = {
	''
}

local action = function(msg)

	local rkgdat = load_data('data/ranking/' .. msg.chat.id_str .. '.json')

	if not rkgdat[msg.from.id_str] then
		rkgdat[msg.from.id_str] = {
			['primeiro_nome'] = msg.from.first_name .. ' (' .. msg.from.id_str .. ')',
			['mensagens'] 	  = 1
		}

		save_data('data/ranking/' .. msg.chat.id_str .. '.json', rkgdat)
	else
		rkgdat[msg.from.id_str] = {
			['primeiro_nome'] = msg.from.first_name .. ' (' .. msg.from.id_str .. ')',
			['mensagens'] 	  = rkgdat[msg.from.id_str]['mensagens'] + 1
		}

		save_data('data/ranking/' .. msg.chat.id_str .. '.json', rkgdat)
	end

	return true

end

return {
	action = action,
	triggers = triggers
}
