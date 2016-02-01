local action = function(msg)
	local input = msg.text:input()
	
if msg.text:match('^/newfile 'input' ') then
	function create_file ( )
  -- A simple file generator ONLY For Groups
  group_file = {
'You Can Put Your important Files in Your GP.lua😆
'
	 },
  }
  serialize_to_file(group_file, './GroupFiles/'input'.lua')
		sendReply(msg, 'New Source File'(msg.chat.id, latcyr(input))' For Group >>>'group_name'<<< Has Been Created! ')
		  print ('saved NewGPFil('input') into ./GroupFiles/'input'.lua')
	end

return {
   description = "Crear archivo en el servidor"
   usage = {
      "/newfile: "
   },
   patterns = {
      "^[!/][Nn]ewfile (.*)$",
   },
   run = run
}

end
