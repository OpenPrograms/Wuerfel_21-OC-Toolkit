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

--Include Libs
local component = require("component")
local computer = require("computer")
local event = require("event")
local natable = require("natable")

--prepare dirty hacks
local header = string.dump(function() end)
local numlength = string.byte(header,11)
local maxpkg
local lastuuids = {}
local uuidlength = os.getenv("DISPENSER_UUID_LENGTH") or 8
local tunnelports = {}
math.randomseed(os.time()-computer.uptime())

local i

--Find Hardware
local hardware = {
  modem = component.isAvailable("modem"),
  tunnel = component.isAvailable("tunnel")
}
for k,v in pairs(hardware) do if v then
  hardware[k]=component.getPrimary(k)
  maxpkg = hardware[k].maxPacketSize()
end end

--Get an UUID
local function getuuid()
  local s = ""
  for i = 1,uuidlength do
    s = s..string.char(math.random(0,255))
  end
  return s
end

--Throw something at the uuid history
local function insertuuid(sender,uuid,port)
  table.insert(lastuuids,1,{sender=sender,uuid=uuid,port=port})
  while #lastuuids > (os.getenv("DIPENSER_HISTORY") or 16) do
    table.remove(lastuuids,1)
  end
end

--Check if a message is evil
local function checkcycle(sender,uuid,port)
  for k,v in ipairs(lastuuids) do
    if (sender == v.sender) and (uuid == v.uuid) and (port == v.port) then
      return false
    end
  end
  insertuuid(sender,uuid,port)
  return true
end

--Check if a message is too fat
local function checksize(list,softport)
  local size = uuidlength
  if softport then size = size + numlength end
  for i = 1,list["n"] do
    local v = list[i]
    if type(v) == "string" then
      size = size + #v
    elseif type(v) == "number" then
      size = size + numlength
    elseif type(v) == "nil" or type(v) == "boolean" then
      size = size + 4
    else
      return false
    end
  end
  if size > maxpkg then
    return false
  else
    return true
  end
end

--You can probably guess that one
local function maxPacketSize(linked)
  local lol = maxpkg - uuidlength
  if linked then lol = lol - numlength end
  return lol
end

--Recieve Messages
local function onMessage(_,reciever,sender,port,distance,...)
  local list = table.pack(...)
  if type(list[1]) ~= "string" then return end
  local linked = port == 0
  if linked then
    sender = "tunnel" port = list[2] natable.remove(list,2)
    local popen = false
    for k,v in pairs(tunnelports) do if k == port and v then popen = true end end
    if not popen then return end
  end
  if checkcycle(sender,list[1],port) then
    natable.remove(list,1)
    computer.pushSignal("dispenser",linked,sender,port,distance,natable.unpack(list))
  end
end

--Send messages
local function send(addr,port,...)
  local list = table.pack(...)
  local uuid = getuuid()
  local linked = addr == "tunnel"
  if checksize(list,linked) then
    if linked then
      hardware.tunnel.send(uuid,port,natable.unpack(list))
    else
      if addr == "broadcast" then
        hardware.modem.broadcast(port,uuid,natable.unpack(list))
      else
        hardware.modem.send(addr,port,uuid,natable.unpack(list))
      end
    end
    return true
  else
    return false
  end
end

--Open ports
local function open(port)
  if (not hardware.modem) or hardware.modem.open(port) then
    tunnelports[port] = true
    return true
  end
  return false
end

--Close ports
local function close(port)
  if (not hardware.modem) or hardware.modem.close(port) then
    if port then
      tunnelports[port] = nil
    else
      tunnelports = {}
    end
    return true
  end
  return false
end

event.listen("modem_message",onMessage)

return {hardware = hardware,checkcycle = checkcycle,checksize = checksize,send=send,open=open,close=close}