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
local fs = require("filesystem")
local shell = require("shell")
local term = require("term")
local serialization = require("serialization")
local keyboard = require("keyboard")
local event = require("event")
local noteal
if fs.isDirectory("/usr/lib/noteal") then
  noteal = require("noteal.noteal")
  noteal.confutil.wcon = nil
end

local appenv = {}
local capp = function() print ("this shouldn't happen") end
local vesion = {stage = "alpha", major = 0, minor = 1, brand = "W21_default"}
local args,options = shell.parse(...)
local addr = args[1]

if #args == 0 then
  print("╔═══════════════════════════════════════╗")
  print("║WsarE alpha v0.1                       ║")
  print("╠═══════════════════════════════════════╣")
  print("║Useage: wsare [address] <file>         ║")
  print("║                                       ║")
  print("║hint: read the manpage!(NYI)           ║")
  print("╚═══════════════════════════════════════╝")
  return "hehe"
elseif #args == 1 then
  args[2] = "default.lua"
end

local modem = component.modem
local gpu = component.gpu

modem.open(42)

local function request(address,reqtype,...)
  modem.send(address,42,reqtype,...)
  local str = ""
  repeat
    local _,_,_,_,_,tmp = event.pull("modem",_,_,42)
    if type(tmp) == "string" then str = str..tmp end
  until tmp == nil
  return str
end

local function runrfile(address,file,reset)
  if reset == true then
    resetaenv()
  end
  local tmp = request(address,"file",file)
  capp = load(tmp,tmp,t,appenv)
  capp()
end

resetaenv = function()
  appenv = {
    wsare = {
      request = request,
      runrfile = runrfile,
      addr = addr,
      version = version,
      options = options,
      },
    noteal = noteal,
    term = term,
    modem = modem,
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

runrfile(addr,args[2],true)
modem.close(42)