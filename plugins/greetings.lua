 -- Colocar este na parte inferior da sua lista de plugins, após help.lua.

local triggers = {
	''
}

local action = function(msg)

	local nicks = load_data('nicknames.json')

	local nick = nicks[msg.from.id_str] or msg.from.first_name

	for k,v in pairs(config.greetings) do
		for key,val in pairs(v) do
			if msg.text_lower:match(val) then
				sendReply(msg, latcyr(k:gsub('#NAME', nick)))
				return
			end
		end
	end

	return true

end

return {
	action = action,
	triggers = triggers
}
