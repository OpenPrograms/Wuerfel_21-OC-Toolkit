--Copyright (C) 2014  Wuerfel_21
--
--This library is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.

--This library is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--Lesser General Public License for more details.

--You should have received a copy of the GNU Lesser General Public
--License along with this library; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

local fs = require("filesystem")
local serial = require("serialization")

local version = "1.2"

local path

local function rcon(name)
  checkArg(1,name,"string")
  name = name .. ".conf"
  if not fs.exists("/etc/"..name) then return false end
  local file = io.open("/etc/"..name,"r")
  local values = serial.unserialize(file:read("*all"))
  file:close()
  return values
end

local function wcon(name,values)
  checkArg(1,name,"string")
  checkArg(2,values,"table")
  name = name .. ".conf"
  local file = io.open("/etc/"..name,"w")
  resp = file:write(serial.serialize(values))
  file:close()
  return resp
end

return {version = version,rcon = rcon,wcon = wcon}