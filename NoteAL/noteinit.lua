--Copyright (C) 2014  Wuerfel_21
--Find license in license.txt
local shell = require("shell")
local confutil = require("noteal.confutil")
print("NoteAL V"..confutil.version.." loaded! Run notehelp for more information.")
shell.setAlias("noteconf","/usr/lib/noteal/noteconf")
shell.setAlias("eventlog","cat /usr/tmp/event.log")
shell.setAlias("notehelp","edit /usr/lib/noteal/read.me -r")