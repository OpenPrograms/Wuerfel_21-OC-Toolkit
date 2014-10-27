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

local event = require("event")
local snl_srv = require("snl_srv")
local serialization = require("serialization")
local shell = require("shell")
local keyboard = require("keyboard")

local args,options = shell.parse(...)

local function getconfig()
  local f = io.open("/etc/snl/snld","r")
  if f == nil then return {} end
  local r = serialization.unserialize(f:read("*all"))
  f:close()
  return r or {}
end

local function setconfig(config)
  local f = io.open("/etc/snl/snld","w")
  f:write(serialization.serialize(config))
  f:close()
end

local function main()
  if args[1] == "start" then
    local config = getconfig()
    if config == nil then error("No config found",0) end
    for hostname,services in pairs(config) do
      for service,dat in pairs(services) do
        snl_srv.addService(service,dat.address,hostname,dat.info)
      end
    end
    while not (keyboard.isControlDown() and keyboard.isKeyDown(keyboard.keys.c)) do
      event.pull()
    end
  elseif args[1] == "addhostname" then
    if args[2] == nil then error("No hostname specified",0) end
    local config = getconfig()
    config[args[2]] = config[args[2]] or {}
    setconfig(config)
  elseif args[1] == "removehostname" then
    if args[2] == nil then error("No hostname specified",0) end
    local config = getconfig()
    config[args[2]] = nil
    setconfig(config)
  elseif args[1] == "addservice" then
    if args[2] == nil then error("No hostname specified",0) end
    if args[3] == nil then error("No service specified",0) end
    if args[4] == nil then error("No address specified",0) end
    local config = getconfig()
    config[args[2]][args[3]] = {info = args[5], address = args[4]}
    setconfig(config)
  elseif args[1] == "removeservice" then
    local config = getconfig()
    if args[2] == nil then error("No hostname specified",0) end
    if args[3] == nil then error("No service specified",0) end
    config[args[2]][args[3]] = nil
    setconfig(config)
  else
    print("▒▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▒")
    print("▌Dedicated SNL Server           ▐")
    print("▌©2014 Wuerfel_21               ▐")
    print("▌Released under the BSD license ▐")
    print("▒▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▒")
  end
end

pcall(main)
snl_srv.shutdown()