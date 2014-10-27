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

local version = "v1.0.0"

local component = require("component")
local dispenser = require("dispenser")
local event = require("event")
local fs = require("filesystem")
local keyboard = require("keyboard")
local serialization = require("serialization")
local shell = require("shell")
local snl_srv

local args,options = shell.parse(...)

if options.s then
  snl_srv = require("snl_srv")
  snl_srv.addService("wsare")
end

local whome = os.getenv("WSARE_HOME") or "/usr/wsare/"
local wdata,wplugins = os.getenv("WSARE_DATA") or whome.."data/",os.getenv("WSARE_PLUGINS") or whome.."plugins/"

local plugins = {}
local listeners = {}

--Loading plugins
local function addListener(event,listener)
  if not listeners[event] then listeners[event] = {} end
  table.insert(listeners[event],listener)
end

local function addPlugin(func,name,...)
  plugins[name] = func
  for k,v in ipairs(table.pack(...)) do
    addListener(v,name)
  end
end

for file in fs.list(wplugins) do
  local path = wplugins..file
  if not fs.isDirectory(path) then
    local raw,reason = loadfile(path)
    if not raw then error(reason) end
    local func = raw()
    addPlugin(func,func("init",version,plugins,whome,wdata,wplugins))
  end
end

local function handleFeedback(feed,...)
  local args = table.pack(...)
  if feed == "answer" then
    local pos = 1
    while true do
      local s = string.sub(args[2],pos,pos+dispenser.maxPacketSize()-1)
      if s == "" then
        dispenser.send(args[1],42,nil)
        break
      else
        dispenser.send(args[1],42,s)
        pos = pos + dispenser.maxPacketSize()
      end
    end
  elseif feed == "tell" then
    dispatchSignal(...)
  elseif feed == "print" then
    print(...)
  elseif feed == "nop" then
    --Play him off, Keyboard Cat!
  end
end

local function dispatchSignal(plugin,...)
  handleFeedback(plugins[plugin](...))
end

local function dispatchToAll(...)
  for k in pairs(plugins) do
    dispatchSignal(k,...)
  end
end

local function handleEvent(name,linked,sender,port,distance,...)
  if name == "dispenser" and port == 42 then
    dispatchToAll("request",sender,distance,...)
  elseif listeners[name] then
    for k,v in ipairs(listeners[name]) do
      dispatchSignal(v,"event",name,linked,sender,port,distance,...)
    end
  end
end

--main loop
dispenser.open(42)
io.write("WsarE server "..version.."\n")
while not (keyboard.isControlDown() and keyboard.isKeyDown(keyboard.keys.c)) do
  handleEvent(event.pull())
end
dispatchToAll("kill")
dispenser.close(42)
if options.s then snl_srv.shutdown() end