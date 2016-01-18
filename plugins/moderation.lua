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
	'^/moderacao[@'..bot.username..']*',
	'^/modajuda[@'..bot.username..']*',
	'^/modlista[@'..bot.username..']*',
	'^/modcast[@'..bot.username..']*',
	'^/modadd[@'..bot.username..']*',
	'^/modrem[@'..bot.username..']*',
	'^/modprom[@'..bot.username..']*',
	'^/modreb[@'..bot.username..']*',
	'^/addbemvindo[@'..bot.username..']*',
	'^/bemvindo[@'..bot.username..']*',
	'^/addregras[@'..bot.username..']*',
	'^/regras[@'..bot.username..']*'
}

local commands = {

	['^/moderacao[@'..bot.username..']*'] = function(msg)

		return 'Chame o ' .. config.admin_username .. ' para que ele possa lhe ajudar com a moderação do seu grupo ou use /modajuda caso eu já esteja moderando este grupo!'

	end,

	['^/modajuda[@'..bot.username..']*'] = function(msg)

		local moddat = load_data('data/moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local message = [[
*Comandos do usuário:*
/modlista - Listar os moderadores e administradores deste grupo
/regras - Ver regras do grupo

*Comandos do moderador:*
/addbemvindo - Adicionar mensagem de 'Bem-vindo' personalizada
/bemvindo - Ativar/desativar mensagens de 'Bem-vindo'
/addregras - Adicionar regras ao grupo
/modprom - Promover um usuário à moderador.
/modreb - Rebaixar um moderador à usuário.

*Comandos do administrador:*
/modadd - Adicionar este grupo ao sistema de moderação
/modrem - Remover este grupo do sistema de moderação
/modcast - Enviar um broadcast para cada grupo moderado
]]

		sendMessage(msg.chat.id, message, true, msg.message_id, true)
		return

	end,

	['^/modlista[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local message = ''

		for k,v in pairs(moddat[msg.chat.id_str]) do
			message = message .. '-> ' .. v .. ' \n'
		end

		if message ~= '' then
			message = 'Moderadores do Grupo ' .. msg.chat.title .. ':\n' .. message .. '\n'
		else
			message = 'Moderadores do Grupo ' .. msg.chat.title .. ' ainda não definidos!'
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

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		local message = msg.text:input()
		if not message then
			return 'Você deve incluir um texto!'
		end

		if msg.chat.id ~= config.moderation.admin_group then
			return 'Comando disponível apenas no grupo dos administradores :['
		end

		local moddat = load_data('data/moderation.json')

		for k, v in pairs(moddat) do
			sendMessage(k, message)
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

		local moddat = load_data('data/moderation.json')

		if moddat[msg.chat.id_str] then
			return 'Eu já estou moderando este grupo!'
		end

		moddat[msg.chat.id_str] = {}
		save_data('data/moderation.json', moddat)
		return 'Agora eu estou moderando este grupo!'

	end,

	['^/modrem[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		if not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_admin
		end

		local moddat = load_data('data/moderation.json')
		local regdat = load_data('data/regras.json')
		local bemdat = load_data('data/bemvindo.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		moddat[msg.chat.id_str] = nil
		save_data('data/moderation.json', moddat)

		regdat[msg.chat.id_str] = nil
		save_data('data/regras.json', regdat)

		bemdat[msg.chat.id_str] = nil
		save_data('data/bemvindo.json', bemdat)

		return 'Eu não estou mais moderando este grupo!'

	end,

	['^/modprom[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local usuario = string.lower(msg.from.username)

		if not moddat[msg.chat.id_str]['@' .. usuario] and not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_mod
		end

		local modname = msg.text:input()

		if not modname then
			return 'Promoções devem ser feitas especificando especificando o nome de usuário dos moderadores!'
		end

		local modname = string.lower(modname)

		if (string.find(modname, '@([%a%d_])')) == nil or string.len(modname) < 6 then
			return 'É necessário o uso de um nome de usuário válido!'
		end

		if moddat[msg.chat.id_str][modname] then
			return modname .. ' já é um moderador!'
		end

		moddat[msg.chat.id_str][modname] = modname
		save_data('data/moderation.json', moddat)

		return modname .. ' é agora um moderador!'

	end,

	['^/modreb[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local usuario = string.lower(msg.from.username)

		if not moddat[msg.chat.id_str]['@' .. usuario] and not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_mod
		end

		local modname = msg.text:input()

		if not modname then
			return 'Rebaixamentos devem ser feitos especificando o nome de usuário dos moderadores!'
		end

		local modname = string.lower(modname)

		if '@' .. usuario == modname then
			return 'Você não pode se rebaixar!'
		end

		if (string.find(modname, '@([%a%d_])')) == nil or string.len(modname) < 6 then
			return 'É necessário o uso de um nome de usuário válido!'
		end

		if not moddat[msg.chat.id_str][modname] then
			return 'O usuário não é um moderador!'
		end

		moddat[msg.chat.id_str][modname] = nil
		save_data('data/moderation.json', moddat)

		return modname .. ' não é mais um moderador!'

	end,

	['^/regras[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')
		local regdat = load_data('data/regras.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		message = regdat[msg.chat.id_str]

		if not message then
			return 'Regras do Grupo ' .. msg.chat.title .. ' ainda não definidas!'
		else
			return message .. '\n\nUse /modlista para ver os moderadores'
		end

		return nil

	end,

	['^/addregras[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')
		local regdat = load_data('data/regras.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local usuario = string.lower(msg.from.username)

		if moddat[msg.chat.id_str]['@' .. usuario] or config.moderation.admins[msg.from.id_str] then

			local regras = msg.text:input()

			if not regras then
				return 'Regras devem ser adicionadas especificando um texto!'
			else
				regdat[msg.chat.id_str] = regras
				save_data('data/regras.json', regdat)
				return 'As regras deste grupo foram definidas com sucesso!'
			end
		else
			return config.errors.not_mod
		end

	end,

	['^/bemvindo[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')
		local bemdat = load_data('data/bemvindo.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local usuario = string.lower(msg.from.username)

		if not moddat[msg.chat.id_str]['@' .. usuario] and not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_mod
		end

		bemvindo = bemdat[msg.chat.id_str]

		if bemvindo == false then
			bemdat[msg.chat.id_str] = true
			save_data('data/bemvindo.json', bemdat)
			return 'As mensagens de \'Bem-vindo\' foram ativadas para este grupo!'
		else
			bemdat[msg.chat.id_str] = false
			save_data('data/bemvindo.json', bemdat)
			return 'As mensagens de \'Bem-vindo\' foram desativadas para este grupo!'
		end

	end,

	['^/addbemvindo[@'..bot.username..']*'] = function(msg)

		if not msg.chat.title then
			return 'Este comando funciona somente em grupos!'
		end

		local moddat = load_data('data/moderation.json')
		local bemdat = load_data('data/bemvindo.json')

		if not moddat[msg.chat.id_str] then
			return config.errors.moderation
		end

		local usuario = string.lower(msg.from.username)

		if not moddat[msg.chat.id_str]['@' .. usuario] and not config.moderation.admins[msg.from.id_str] then
			return config.errors.not_mod
		end

		local bemvindo = msg.text:input()

		if not bemvindo then
			message = 'A mensagem de \'Bem-vindo\' personalizada deve ser adicionada especificando um texto!\nUse "/addbemvindo -" para a mensagem padrão.\n\nUse *$nome*, *$usuario* ou *$grupo* para criar a mensagem personalizada. Exemplo:\n\n/addbemvindo Olá *$nome*, seja bem-vindo(a) ao Grupo *$grupo*. Fique à vontade *$usuario* ;]'
			sendMessage(msg.chat.id, message, true, msg.message_id, true)
			return
		elseif bemvindo == '-' then
			bemdat[msg.chat.id_str] = nil
			save_data('data/bemvindo.json', bemdat)
			return 'A mensagem personalizada de \'Bem-vindo\' deste grupo foi definida para o padrão!'
		else
			bemdat[msg.chat.id_str] = bemvindo
			save_data('data/bemvindo.json', bemdat)
			return 'A mensagem personalizada de \'Bem-vindo\' deste grupo foi definida com sucesso!'
		end

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
