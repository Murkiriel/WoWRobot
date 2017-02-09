HTTP = require('socket.http')
HTTPS = require('ssl.https')
URL = require('socket.url')
JSON = require('dkjson')

version = '3.2'
version_wow = '1.4.1'

bot_init = function() -- A função é executada quando o bot é iniciado ou recarregado

	config = dofile("config.lua") -- Carrega arquivo de configuração
	dofile("bindings.lua") -- Carrega bindings do Telegram
	dofile("utilities.lua") -- Carrega mistos e funções cross-plugins

	-- Buscar informações sobre o bot. Tente até que tenha êxito
	repeat bot = getMe() until bot

	bot = bot.result

	plugins = {} -- Carrega plugins
	for i,v in ipairs(config.plugins) do
		local p = dofile("plugins/"..v)
		table.insert(plugins, p)
	end

	print('@'..bot.username .. ', AKA ' .. bot.first_name ..' ('..bot.id..')')

	-- Gerar uma semente aleatória e "pop" o primeiro número aleatório :)
	math.randomseed(os.time())
	math.random()

	last_update = last_update or 0 -- Definir variáveis de loop: atualização do offset
	last_cron = last_cron or os.time() -- O tempo da última cron job
	is_started = true -- Se o bot deve ser executado ou não
	usernames = usernames or {} -- Tabela para armazenar em cache nome de usuário por ID do usuário

end

on_msg_receive = function(msg) -- Executar função sempre que uma mensagem é recebida

	if msg then
		if msg.from.username then
			usernames[msg.from.username:lower()] = msg.from.id
		end

		if msg.date < os.time() - 5 then return end -- Não processar mensagens antigas
		if not msg.text then msg.text = msg.caption or '' end

		if msg.text:match('^/start .+') then
			msg.text = '/' .. msg.text:input()
		end

		for i,v in ipairs(plugins) do
			for k,w in pairs(v.triggers) do
				if string.match(msg.text:lower(), w) then

					-- Alguns atalhos
					msg.chat.id_str = tostring(msg.chat.id)
					msg.from.id_str = tostring(msg.from.id)
					msg.text_lower = msg.text:lower()

					local success, result = pcall(function()
						return v.action(msg)
					end)
					if not success then
						sendReply(msg, 'Ocorreu um erro inesperado')
						handle_exception(result, msg.text)
						return
					end
					-- Se a ação retorna uma tabela, verifique a tabela de mensagens
					if type(result) == 'table' then
						msg = result
					-- Se a ação retornar verdadeiro, não pare
					elseif result ~= true then
						return
					end
				end
			end
		end
	end
end

bot_init() -- Inicia o script de verdade. Executa a função bot_init

while is_started do -- Começa um loop enquanto o bot está em execução

	local res = getUpdates(last_update+1) -- Obter as últimas atualizações!
	if res then
		for i,v in ipairs(res.result) do -- Vá através de cada nova mensagem
			last_update = v.update_id
			on_msg_receive(v.message)
		end
	end

	if last_cron < os.time() - 5 then -- Executar cron jobs de quem chegou o momento
		for i,v in ipairs(plugins) do
			if v.cron then -- Chamar função cron de cada plugin, se ele tiver um
				local res, err = pcall(function() v.cron() end)
				if not res then
					handle_exception(err, 'CRON: ' .. i)
				end
			end
		end
		last_cron = os.time() -- E, finalmente, atualiza a variável
	end

end

print('Halted.')
