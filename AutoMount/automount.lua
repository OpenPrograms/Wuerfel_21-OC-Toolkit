--Copyright (C) 2014  Wuerfel_21
--
--This program is free software; you can redistribute it and/or modify
--it under the terms of the GNU General Public License as published by
--the Free Software Foundation; either version 2 of the License, or
--(at your option) any later version.
--
--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--GNU General Public License for more details.
--
--You should have received a copy of the GNU General Public License along
--with this program; if not, write to the Free Software Foundation, Inc.,
--51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

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