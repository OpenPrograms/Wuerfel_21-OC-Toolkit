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

local component = require("component")
local fs = require("filesystem")
local shell = require("shell")

args,options = shell.parse(...)

if #args < 2 then
  print("Arrr, pirates be talkin' like this:\nfloppypirate <from> <to>")
  return "Arrr"
end

--get me strigns(that typo is intended)
local fromstr = assert(component.get(args[1],"filesystem"))
local tostr = assert(component.get(args[2],"filesystem"))

--they should be different
if fromstr == tostr then error("Arrr, Arguments can't be equal") end

--now make them proxys
from = assert(fs.proxy(fromstr))
to = assert(fs.proxy(tostr))

--some more checks
if from.spaceUsed() > to.spaceTotal() then error("Arrr,i be a pirate, not a wizard!(from is bigger than to)") end

print("Arrr, pirate will overwrite everytin, type in \"Aye-Aye\" ")
if not (io.read("*line") == "Aye-Aye") then
  print("Arrr, Aborted")
  return "Arrr"
end

--let the show begin
print("Aye-Aye!")
to.setLabel(from.getLabel())
fs.umount("/tmp/from/")
fs.umount("/tmp/to/")
fs.mount(fromstr,"/tmp/from/")
fs.mount(tostr,"/tmp/to/")

local function cpdir(dir)
  print("dir:",dir)
  for k,v in pairs(from.list(dir)) do
    print("processing:",k,v)
    if type(v) == "number" then return nil end
    if from.isDirectory(dir..v) then
      print("mkdir:",dir..v,to.makeDirectory(dir..v))
      cpdir(dir..v)
    else
      print("cp:",fs.copy("/tmp/from/"..dir..v,"/tmp/to/"..dir..v))
    end 
  end
end

cpdir("/")
fs.umount("/tmp/from/")
fs.umount("/tmp/to/")
print("Plundred!")