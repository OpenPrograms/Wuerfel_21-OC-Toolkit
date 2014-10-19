--Copyright (C) 2014  Wuerfel_21
--
--This program is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--Lesser General Public License for more details.

--You should have received a copy of the GNU Lesser General Public
--License along with this lprogram; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

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
