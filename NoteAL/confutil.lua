local fs = require("filesystem")
local serial = require("serialization")

local version = "1.0"

local path

local function rcon(name)
  checkArg(1,name,"string")
  name = name .. ".conf"
  if fs.exists("/tmp/" .. name) then
    path = "/tmp/" .. name
  elseif fs.exists("/home/" .. name) then
    path = "/home/" .. name
  else
    return false
  end
  local file = io.open(path,"r")
  local values = serial.unserialize(file:read("*all"))
  file:close()
  return values
end

local function wcon(name,values)
  checkArg(1,name,"string")
  checkArg(2,values,"table")
  name = name .. ".conf"
  if fs.exists("/tmp/"..name) then
    path = "/tmp/" .. name
  elseif fs.exists("/home/"..name) then
    path = "/home/" .. name
  elseif fs.exists("/home/") then
    path = "/home/" .. name
  else
    path = "/tmp/" .. name
  end
  local file = io.open(path,"w")
  resp = file:write(serial.serialize(values))
  file:close()
  return resp
end

return {version = version,rcon = rcon,wcon = wcon}