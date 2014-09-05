--Copyright (C) 2014  Wuerfel_21
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation; either version 2 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

local component = require("component")
local event = require("event")
local fs = require("filesystem")
local shell = require("shell")
local keyboard = require("keyboard")
local snl_srv


local args,options = shell.parse(...)
local modem
if component.isAvailable("modem") then
  modem = component.modem
else
  error("No modem detected!!!\nCan't start!")
end

if #args and modem.isWireless() and tonumber(args[1]) then
  modem.setStrength(tonumber(args[1]))
end

local function onModemMessage(_,_,client,port,_,instruction,request)
  if port ~= 42 then return end
  if not instruction == "file" then return end
  io.write("Got request!",client,request,"\n")
  local request = shell.getWorkingDirectory().."data/"..request
  if (not fs.exists(request)) or fs.isDirectory(request) then
    return
  end
  local file = io.open(request)
  local i = ""
  while i do
    i = file:read(modem.maxPacketSize())
    modem.send(client,42,i)
  end
  file:close()
  io.write("request finished!\n")
end

io.write("WsarE server v0.0.1 - find license in license.txt\nmodem on "..modem.address.."\n")
local f = io.open(shell.getWorkingDirectory().."modem.addr","w")
if f then f:write(modem.address) f:close() end

if options.s then
  snl_srv = require("snl_srv")
  snl_srv.addService("wsare")
end
modem.open(42)

event.listen("modem_message",onModemMessage)


while true do
  event.pull()
  if keyboard.isControlDown() then
    event.ignore("modem_message",onModemMessage)
    modem.close(42)
    if options.s then snl_srv.shutdown() end
    return "derp"
  end
end