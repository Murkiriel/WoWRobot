return {
	bot_api_key = '', -- # TOKEN DO SEU BOT
	google_api_key = '',
	google_cse_key = '',
	lastfm_api_key = '',
	owm_api_key = '',
	biblia_api_key = '',
	thecatapi_key = '',
	nasa_api_key = '',
	time_offset = 0,
	lang = 'pt', -- # SEU IDIOMA
	antisquig = false,
	cli_port = 4567,
	admin = 000000, -- # SEU ID AQUI
	admin_name = '', -- # SEU NOME AQUI
	admin_username = '@', -- # SEU NOME DE USUÁRIO AQUI
	log_chat = nil,
	about_text = '',
	tmp = '/tmp/',

	errors = {
		connection	   = 'Erro de conexão.',
		results		   = 'Nenhum resultado encontrado.',
		argument	   = 'Argumento inválido.',
		syntax		   = 'Sintaxe inválida.',
		antisquig	   = 'Este grupo é apenas em Português.',
		moderation	   = 'Eu não modero este grupo.',
		not_mod		   = 'Este comando deve ser executado por um moderador ou administrador.',
		not_admin	   = 'Este comando deve ser executado por um administrador.',
		chatter_connection = 'Eu não me sinto com vontade de falar agora.',
		chatter_response   = 'Eu não sei o que dizer sobre isso.'
	},
	greetings = {
		['Olá, #NAME'] = {
			'olá',
			'ei',
			'oi',
			'bom dia',
			'boa tarde',
			'boa noite',
			'boa madrugada'
		},
		['Adeus, #NAME'] = {
			'adeus',
			'até logo'
		},
		['Bem vindo de volta, #NAME'] = {
			'Estou em casa',
			'estou de volta'
		},
		['De nada, #NAME'] = {
			'obrigado'
		}
	},
	moderation = {
		admins = {
			['000000'] = '' -- # ID E NOME DOS ADMINISTADORES
		},
		admin_group = -000000, -- # ID DO GRUPO DOS ADMINISTADORES
		realm_name = '' -- # NOME DO GRUPO DOS ADMINISTADORES
	},
	plugins = {
		'moderation.lua',
		'control.lua',
		'blacklist.lua',
		'about.lua',
		'floodcontrol.lua',
		'nick.lua',
		'calc.lua',
		'convidar.lua',
		'echo.lua',
		'currency.lua',
		'cats.lua',
		'gSearch.lua',
		'shout.lua',
		'hackernews.lua',
		'whoami.lua',
		'imdb.lua',
		'gMaps.lua',
		'ping.lua',
		'pokedex.lua',
		'ranking_data.lua',
		'ranking.lua',
		'reddit.lua',
		'wikipedia.lua',
		'xda.lua',
		'youtube.lua',
		'help.lua',
		-- Colocar novos plugins aqui
		--'greetings.lua',
		'chatter.lua'
	}
}
