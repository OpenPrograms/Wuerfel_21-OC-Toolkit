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

local fs = require("filesystem")
local shell = require("shell")
--Send me a PM with "duh" in it and i will derp you to hell
local args,options = shell.parse(...)

if #args < 2 then
  print("~~~ AutoMount V0.9.0.0.1 ~~~\nThis is a Tool to save you from writing derpy autoruns over and over again!\nOhh and use it like:\nautomount [a label or address] [a mount point]")
  return "derp, why do you still read my return values?"
end

local proxy = fs.proxy(args[1])
if not proxy then
  print("Invalid label or address")
  return "why the ueber crappy ultra omega super derpy heck are you reading this pretty long string, go home, NOW!"
end

fs.umount(args[1])
if fs.exists(args[2]) then
  print("Mount point is already taken")
  return "still there?"
end

fs.mount(proxy,"/tmp/amtmp")
local autorunfile = io.open("/tmp/amtmp/autorun.lua","w")
autorunfile:write('local fs = require("filesystem")\nfs.mount(...,"' .. args[2] .. '")')
autorunfile:close()
fs.umount(args[1])
print("now reboot or re-insert the floppy/hdd")