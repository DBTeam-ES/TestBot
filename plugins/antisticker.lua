local DVName = "StickerLock"

function checkper( msg )
    if (  is_realm(msg) and is_admin(msg) or is_sudo(msg) or is_momod(msg) )  then
        return true;
    else 
    	return false;
    end
end

function checkMedia(msg)
	local TYPE = nil
	if ( msg.media ) then
		TYPE = msg.media.type end
	return TYPE
end

function checkLockState( msg, data )
	if ( data[tostring(msg.to.id)]["settings"]["StickerLock"] == "yes" ) then
		return true;
	elseif ( data[tostring(msg.to.id)]["settings"]["StickerLock"] == "no" ) then
		return false;
	else 
		return nil 
	end
end

function LockStickers(msg, data)
	if ( not checkper(msg) ) then
		return; end
	if ( data[tostring(msg.to.id)]["settings"]["StickerLock"] == "yes" ) then
		return "Stickers Bloqueados :)";
	else
		data[tostring(msg.to.id)]["settings"]["StickerLock"] = "yes"
		return "Stickers Bloqueados :)"
	end
	save_data(_config.moderation.data, data);
end

function UnLockStickers(msg, data)
	if ( not checkper(msg) ) then
		return; end
	if ( data[tostring(msg.to.id)]["settings"]["StickerLock"] == "no" ) then
		return "Stickers Desbloqueados :)";
	else
		data[tostring(msg.to.id)]["settings"]["StickerLock"] = "no"
		return "Stickers Desbloqueados :)"
	end
	save_data(_config.moderation.data, data);	
end

function getLockState(msg, data)
	if ( data[tostring(msg.to.id)]["settings"]["StickerLock"] == "yes" ) then
		return "Stickers Bloqueados :) ";
	elseif ( data[tostring(msg.to.id)]["settings"]["StickerLock"] == "no" ) then
		return "Stickers Desbloqueados :) ";
	end
end

function pre_process_service_msg(msg)
   if msg.service then
      local action = msg.action or {type=""}
      -- Double ! to discriminate of normal actions
      msg.text = "!!tgservice " .. action.type

      -- wipe the data to allow the bot to read service messages
      if msg.out then
         msg.out = false
      end
      if msg.from.id == our_id then
         msg.from.id = 0
      end
   end
   return msg
end

function pre_process_msg(msg)
  for name,plugin in pairs(plugins) do
    if plugin.pre_process and msg then
      print('Preprocess', name)
      msg = plugin.pre_process(msg)
    end
  end

  return msg
end

do

function on_msg_receive( msg )
	data = load_data(_config.moderation.data);
	R = 'chat#id'..msg.to.id;
	if ( msg.text == "/st on" ) then
		send_large_msg ( R , LockStickers(msg, data) );
		save_data(_config.moderation.data, data);
		
	elseif ( msg.text == "/st off" ) then
		send_large_msg ( R , UnLockStickers(msg, data) );
		save_data(_config.moderation.data, data);
		
	elseif ( msg.text == "/st info" ) then
		send_large_msg ( R , getLockState(msg, data) );
	end


	if ( checkMedia(msg) and checkLockState(msg, data) ) then
		if ( not checkper(msg) ) then
 			local user = "user#id" .. msg.from.id
			send_large_msg ( R , "No vuelvas a hacerlo :)" );
			chat_del_user(R, user, ok_cb, true)
 		end
	end

  	msg = pre_process_service_msg(msg)
  	if msg_valid(msg) then
    	msg = pre_process_msg(msg)
    	if msg then
      		match_plugins(msg)
    	end
 	end
end



return {
	patterns = {
		"/(sticker) (.+)"
  	},
  	run = run
} 

end
