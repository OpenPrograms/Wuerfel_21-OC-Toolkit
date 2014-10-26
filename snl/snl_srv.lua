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

local modem = assert(component.modem,"Modem required!")

local services = {}

local hostname
local hfile = io.open("/etc/snl/hostname","r")
if hfile ~= nil then hostname = hfile:read("*all") hfile:close() end
hostname = os.getenv("SNL_HOSTNAME") or hostname
if hostname == nil then 
  fs.makeDirectory("/etc/snl")
  local hfile = io.open("/etc/snl/hostname","w")
  math.randomseed(os.time())
  hostname = "nohostnamefound"..tostring(math.random(21^3))
  hfile:write(hostname)
  hfile:close()
end

local function addService(service,address,name,info)
  table.insert(services,{
    service = service or "nop",
    address = address or modem.address,
    name = name or hostname,
    info = info})
  return #services
end

local function removeService(id)
  table.remove(services,id)
end

local function onModemMessage(_,_,client,port,_,name,service)
  if port ~= 9261 then return end
  for k,v in pairs(services) do
    if v.service == service and v.name == name then
      modem.send(client,9261,v.address,v.info)
      return
    end
  end
end

local function shutdown()
  services = {}
  event.ignore("modem_message",onModemMessage)
  package.loaded.snl_srv = nil
  modem.close(9261)
end

event.listen("modem_message",onModemMessage)
modem.open(9261)

return {hostname = hostname,addService = addService,removeService = removeService,shutdown = shutdown}
