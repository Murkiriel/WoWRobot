 -- Plugin para convidar o bot

local command_id = '4'
local command = 'convidar'

local doc = [[
	/convidar

Me convide para o seu grupo e deixe ele WoW!!!
]]

local triggers = {
	'^/convidar[@'..bot.username..']*'
}

local action = function(msg)
	sendReply(msg, 'Me convide para o seu grupo e deixe ele WoW!!!\n\nhttps://telegram.me/' .. bot.username .. '?startgroup=new')
end

return {
	action = action,
	triggers = triggers,
	doc = doc,
	command = command,
	command_id = command_id
}
