 -- Controle de flood compatível com Liberbot
 -- Poloque isso depois de moderation.lua ou blacklist.lua

floodcontrol = floodcontrol or {}

local triggers = {
	''
}

local action = function(msg)

	if floodcontrol[-msg.chat.id] then
		return
	end

	local input = msg.text_lower:match('^/antiflood[@'..bot.username..']* (.+)')
	if not input then return true end

	if msg.from.id ~= 100547061 and msg.from.id ~= config.admin then
		return -- Só executar para Liberbot ou o administrador
	end

	input = JSON.decode(input)

	if not input.groupid then
		return
	end
	if not input.duration then
		input.duration = 600
	end

	floodcontrol[input.groupid] = os.time() + input.duration

	local output = input.groupid .. ' silenciado por ' .. input.duration .. ' segundos.'
	handle_exception('floodcontrol.lua', output)

end

local cron = function()

	for k,v in pairs(floodcontrol) do
		if os.time() > v then
			floodcontrol[k] = nil
		end
	end

end

return {
	action = action,
	triggers = triggers,
	cron = cron
}
