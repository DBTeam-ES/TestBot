 -- This plugin will allow the admin to blacklist users who will be unable to
 -- use the bot. This plugin should be at the top of your plugin list in config.

local triggers = {
	''
}

 local action = function(msg)

	local blacklist = load_data('blacklist.json')

	if blacklist[msg.from.id_str] then
		return -- End if the sender is blacklisted.
	end

	if not string.match(msg.text_lower, '^/blacklist') then
		return true
	end

	if msg.from.id ~= config.admin then
    sendReply(msg, 'Não quero...')
		return -- End if the user isn't admin.
	end

	local input = msg.text:input()
	if not input then
		if msg.reply_to_message then
			input = tostring(msg.reply_to_message.from.id)
		else
			sendReply(msg, 'Amigo, Coloca o ID.')
			return
		end
	end

	if blacklist[input] then
		blacklist[input] = nil
		sendReply(msg, input .. ' Saiu - blacklist.')
	else
		blacklist[input] = true
		sendReply(msg, input .. ' Entrou - blacklist.')
	end

	save_data('blacklist.json', blacklist)

 end

 return {
	action = action,
	triggers = triggers
}
