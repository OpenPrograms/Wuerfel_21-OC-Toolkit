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