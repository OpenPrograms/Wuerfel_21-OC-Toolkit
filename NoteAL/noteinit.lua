--Copyright (C) 2014  Wuerfel_21
--Find license in license.txt
local shell = require("shell")
local confutil = require("noteal.confutil")
print("\nNoteAL loader by Wuerfel_21")
print("NoteAL "..confutil.version.." mounted in /usr/lib/noteal!")
print("If you want to use NoteAL run \"notehelp\" to get more informtion")
shell.setAlias("noteconf","/us/lib/noteal/noteconf")
shell.setAlias("eventlog","cat /usr/tmp/event.log")
shell.setAlias("notehelp","edit /usr/lib/noteal/read.me -r")