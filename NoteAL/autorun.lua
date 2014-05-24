local component = require("component")
local fs = require("filesystem")
local term = require("term")
local shell = require("shell")
local proxy = ...
fs.mount(proxy,"/lib/noteal")
local confutil = require("noteal.confutil") --requireing after mounting it in the right place
print("\nNoteAL loader by Wuerfel_21")
print("NoteAL "..confutil.version.." mounted in /lib/noteal!")
print("If you want to use NoteAL run \"notehelp\" to get more informtion")
if not confutil.rcon("noteal") then --we dont have a config
error("No noteal.conf found, maybe we didnt have /home mounted?")
end
shell.setAlias("noteconf","/lib/noteal/noteconf")
shell.setAlias("eventlog","cat /tmp/event.log")
shell.setAlias("notehelp","edit /lib/noteal/read.me -r")