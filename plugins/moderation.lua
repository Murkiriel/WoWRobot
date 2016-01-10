 -- Moderação para grupos Liberbot
 -- O bot deve ser feito por um administrador
 -- Colocar este perto do topo, depois da blacklist
 -- Se você quiser ativar antisquig, colocar isso no topo, antes de lista negra

local command_id = '0'
local command = 'moderacao'

local doc = [[
	/moderacao

Sistema de moderação para grupos
]]


local triggers = {
	'^/modajuda[@'..bot.username..']*',
	'^/modlista[@'..bot.username..']*',
	'^/modcast[@'..bot.username..']*',
	'^/modadd[@'..bot.username..']*',
	'^/modrem[@'..bot.username..']*',
	'^/modprom[@'..bot.username..']*',
	'^/modreb[@'..bot.username..']*',
	'^/kickar[@'..bot.username..']*',
	'^/banir[@'..bot.username..']*',
	'^/addregras[@'..bot.username..']*',
	'^/regras[@'..bot.username..']*',
	'^/moderacao[@'..bot.username..']*',
	'^/bemvindo[@'..bot.username..']*'
}

local commands = {

	['^/moderacao[@'..bot.username..']*'] = function(msg)

		return 'Chame o @' .. config.admin_name .. ' para que ele possa lhe ajudar com a moderação do seu grupo'

	end,

	['^/modajuda[@'..bot.username..']*'] = function(msg)

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local message = [[
/modlista - Listar os moderadores e administradores deste grupo
/regras - Ver regras do grupo

Comandos do administrador:
/addregras - Adicionar regras ao grupo
/bemvindo - Ativar/desativar mensagens de 'Bem-vindo'
/modadd - Adicionar este grupo ao sistema de moderação
/modrem - Remover este grupo do sistema de moderação
/modprom - Promover um usuário à moderador.
/modreb - Rebaixar um moderador à usuário.
/modcast - Enviar um broadcast para cada grupo moderado
]]

		return message

	end,

	['^/modlista[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local message = ''

		for k,v in pairs(moddat[msg.chat.id_str]) do
			message = message .. ' - ' .. v .. ' \n'
		end

		if message ~= '' then
			message = 'Moderadores do Grupo ' .. msg.chat.title .. ':\n' .. message .. '\n'
		else
			message = 'Moderadores do Grupo ' .. msg.chat.title .. ' ainda não definidos'
		end

		--message = message .. 'Administradores do Grupo ' .. config.moderation.realm_name .. ':\n'
		--for k,v in pairs(config.moderation.admins) do
			--message = message .. ' - ' .. v .. ' (' .. k .. ')\n'
		--end

		return message

	end,

	['^/modcast[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local message = msg.text:input()
		if not message then
			return 'Você deve incluir uma mensagem'
		end

		if msg.chat.id ~= config.moderation.admin_group then
			return 'Você não possui poderes para isso :['
		end

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		local moddat = load_data('moderation.json')

		for k,v in pairs(moddat) do
			i, j = string.find(k, 'regras')

			if i == nil then
				sendMessage(k, message)
			end
		end

		return 'O seu broadcast foi enviado'

	end,

	['^/modadd[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		local moddat = load_data('moderation.json')

		if moddat[msg.chat.id_str] then
			return 'Eu já estou moderando este grupo'
		end

		moddat[msg.chat.id_str] = {}
		save_data('moderation.json', moddat)
		return 'Agora eu estou moderando este grupo'

	end,

	['^/modrem[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		moddat[msg.chat.id_str] = nil
		save_data('moderation.json', moddat)
		return 'Eu não estou mais moderando este grupo'

	end,

	['^/modprom[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		if not msg.reply_to_message then
			return 'Promoções devem ser feitas através de menções'
		end

		local modid = tostring(msg.reply_to_message.from.id)
		local modname = msg.reply_to_message.from.first_name

		if msg.reply_to_message.from.username then
			modname = modname .. ' (@' .. msg.reply_to_message.from.username .. ')'
		end

		if config.moderation.admins[modid] then
			return modname .. ' já é um administrador'
		end

		if moddat[msg.chat.id_str][modid] then
			return modname .. ' já é um moderador'
		end

		moddat[msg.chat.id_str][modid] = modname
		save_data('moderation.json', moddat)

		return modname .. ' é agora um moderador'

	end,

	['^/modreb[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		local modid = msg.text:input()

		if not modid then
			if msg.reply_to_message then
				modid = tostring(msg.reply_to_message.from.id)
			else
				return 'Rebaixamentos devem ser feitos por meio de menções ou especificando um ID dos moderadores'
			end
		end

		if config.moderation.admins[modid] then
			return config.moderation.admins[modid] .. ' é um administrador'
		end

		if not moddat[msg.chat.id_str][modid] then
			return 'O usuário não é um moderador'
		end

		local modname = moddat[msg.chat.id_str][modid]
		moddat[msg.chat.id_str][modid] = nil
		save_data('moderation.json', moddat)

		return modname .. ' não é mais um moderador'

	end,

	['^/bemvindo[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		bemvindo = moddat['bemvindo-' .. msg.chat.id_str]

		if bemvindo == false then
			moddat['bemvindo-' .. msg.chat.id_str] = true
			save_data('moderation.json', moddat)
			return 'As mensagens de \'Bem-vindo\' foram ativadas para este grupo!'
		else
			moddat['bemvindo-' .. msg.chat.id_str] = false
			save_data('moderation.json', moddat)
			return 'As mensagens de \'Bem-vindo\' foram desativadas para este grupo!'
		end

	end,

	['^/regras[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		message = moddat['regras' .. msg.chat.id_str]

		if not message then
			return 'Regras do grupo ainda não definidas!'
		else
			sendReply(msg, message .. '\n\nUse /modlista para ver os moderadores')
		end

		return nil

	end,

	['^/addregras[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		local regras = msg.text:input()

		if not regras then
			if msg.reply_to_message then
				regras = tostring(msg.reply_to_message.text)
			else
				return 'Regras devem ser adicionadas por meio de menções ou especificando um texto'
			end
		end

		moddat['regras' .. msg.chat.id_str] = regras
		save_data('moderation.json', moddat)

		return 'As regras deste grupo foram definidas com sucesso!'

	end,

	['/kickar[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		if not moddat[msg.chat.id_str][msg.from.id_str] then
			if not config.moderation.admins[msg.from.id_str] then
				return config.errors.not_mod
			end
		end

		local userid = msg.text:input()
		local usernm = userid

		if msg.reply_to_message then
			userid = tostring(msg.reply_to_message.from.id)
			usernm = msg.reply_to_message.from.first_name
		end

		if not userid then
			return 'Kicks devem ser feitos por meio de menções, especificando um ID dos usuários/bots ou nome de usuário'
		end

		if moddat[msg.chat.id_str][userid] or config.moderation.admins[userid] then
			return 'Você não pode kickar um moderador'
		end

		sendMessage(config.moderation.admin_group, '/kick ' .. userid .. ' de ' .. math.abs(msg.chat.id))

		sendMessage(config.moderation.admin_group, usernm .. ' kickado de ' .. msg.chat.title .. ' por ' .. msg.from.first_name .. '.')

	end,

	['^/banir[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		if not moddat[msg.chat.id_str][msg.from.id_str] then
			if not config.moderation.admins[msg.from.id_str] then
				return config.errors.not_mod
			end
		end

		local userid = msg.text:input()
		local usernm = userid

		if msg.reply_to_message then
			userid = tostring(msg.reply_to_message.from.id)
			usernm = msg.reply_to_message.from.first_name
		end

		if not userid then
			return 'Banimentos devem ser feitos por meio de menções, especificando um ID dos usuários/bots ou nome de usuário'
		end

		if moddat[msg.chat.id_str][userid] or config.moderation.admins[userid] then
			return 'Você não pode banir um moderador'
		end

		sendMessage(config.moderation.admin_group, '/ban ' .. userid .. ' de ' .. math.abs(msg.chat.id))

		sendMessage(config.moderation.admin_group, usernm .. ' banido de ' .. msg.chat.title .. ' por ' .. msg.from.first_name .. '.')

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
	command = command,
	command_id = command_id
}
