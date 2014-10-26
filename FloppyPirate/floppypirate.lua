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