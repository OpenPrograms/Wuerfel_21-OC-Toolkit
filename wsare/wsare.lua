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
local fs = require("filesystem")
local shell = require("shell")
local term = require("term")
local serialization = require("serialization")
local keyboard = require("keyboard")
local event = require("event")
local snl_clt = require("snl_clt")
local dispenser = require("dispenser")
local noteal
if fs.isDirectory("/usr/lib/noteal") then
  noteal = require("noteal.noteal")
  noteal.confutil.wcon = nil
end

local appenv = {}
local capp = function() print ("this shouldn't happen") end
local vesion = {stage = "alpha", major = 0, minor = 1, brand = "W21_default"}
local args,options = shell.parse(...)
local addr,file

local gpu = component.gpu

if #args == 0 then
  local fg,bg = gpu.getForeground(),gpu.getBackground()
  gpu.setForeground(bg)
  gpu.setBackground(fg)
  print("╔═══════════════════════════════════════╗")
  print("║WsarE alpha v0.1                       ║")
  print("╠═══════════════════════════════════════╣")
  print("║©2014 Wuerfel_21                       ║")
  print("║Distrubuted under the BSD license      ║")
  print("║hint: read the manpage!                ║")
  print("╚═══════════════════════════════════════╝")
  gpu.setForeground(fg)
  gpu.setBackground(bg)
  return "hehe"
end

dispenser.open(42)

local function request(address,reqtype,...)
  dispenser.send(address,42,reqtype,...)
  local str = ""
  repeat
    local _,_,_,_,_,tmp = event.pull("dispenser",_,address,42)
    if type(tmp) == "string" then str = str..tmp end
  until tmp == nil
  return str
end

local function runrfile(address,file,reset)
  if reset == true then
    resetaenv(address,file)
  end
  local tmp = request(address,"file",file)
  capp,bla = load(tmp,tmp,t,appenv)
  capp()
end

resetaenv = function(add,fil)
  appenv = {
    wsare = {
      request = request,
      runrfile = runrfile,
      addr = add,
      file = fil,
      version = version,
      options = options,
      },
    dispenser = dispenser,
    noteal = noteal,
    snl_clt = snl_clt,
    term = term,
    modem = dispenser.hardware.modem,
    gpu = gpu,
    event = event,
    keyboard = keyboard,
    serialization = serialization,
    coroutine = coroutine,
    print = print,
    pairs = pairs,
    ipairs = ipairs,
    type = type,
    assert = assert,
    error = error,
    next = next,
    pcall = pcall,
    tonumber = tonumber,
    tostring = tostring,
    string = string,
    table = table,
    math = math,
    sleep = os.sleep
    }
end

if options.a then
  runrfile(args[1],args[2] or "default.lua",true)
else
  addr,file = snl_clt.getservice(args[1],args[3] or "wsare")
  if addr == nil then 
    error("invalid hostname or service!",0)
  end
  file = args[2] or file or "default.lua"
  runrfile(addr,file,true)
end
dispenser.close(42)