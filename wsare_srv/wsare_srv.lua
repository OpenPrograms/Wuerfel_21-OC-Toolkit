--Copyright (c) 2014, Wuerfel_21
--All rights reserved.
--
--Redistribution and use in source and binary forms, with or without
--modification, are permitted provided that the following conditions are met:
--
--* Redistributions of source code must retain the above copyright notice, this
--  list of conditions and the following disclaimer.
--
--* Redistributions in binary form must reproduce the above copyright notice,
--  this list of conditions and the following disclaimer in the documentation
--  and/or other materials provided with the distribution.
--
--THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
--DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
--FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
--DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
--SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
--CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
--OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

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

io.write("WsarE server v0.0.1\nmodem on "..modem.address.."\n")
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
  if keyboard.isControlDown() and keyboard.isKeyDown(keyboard.keys.c) then
    event.ignore("modem_message",onModemMessage)
    modem.close(42)
    if options.s then snl_srv.shutdown() end
    return "derp"
  end
end