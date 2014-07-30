--Copyright (C) 2014  Wuerfel_21
--Find license in license.txt
local shell = require("shell")
local confutil = require("noteal.confutil")
print("\nNoteAL loader by Wuerfel_21")
print("NoteAL "..confutil.version.." mounted in /lib/noteal!")
print("If you want to use NoteAL run \"notehelp\" to get more informtion")
shell.setAlias("noteconf","/lib/noteal/noteconf")
shell.setAlias("eventlog","cat /tmp/event.log")
shell.setAlias("notehelp","edit /lib/noteal/read.me -r")