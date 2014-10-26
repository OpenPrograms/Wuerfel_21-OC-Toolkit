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

local shell = require("shell")
local component = require("component")
local keyboard = require("keyboard")
local event = require("event")
local note = require("note")
local computer = require("computer")
local fs = require("filesystem")

local args,options = shell.parse(...)

local MagicTable = {}

--stuff to make life easier
local noteb
local noteal

--this saves me from typing "keyboard" over and over again
local keys = keyboard.keys

local function MakeTheMagicHappen() --Fill MagicTable with keybindings
  MagicTable[keys["1"]] = 1
  MagicTable[keys["q"]] = 2
  MagicTable[keys["2"]] = 3
  MagicTable[keys["w"]] = 4
  MagicTable[keys["3"]] = 5
  MagicTable[keys["e"]] = 6
  MagicTable[keys["r"]] = 7
  MagicTable[keys["5"]] = 8
  MagicTable[keys["t"]] = 9
  MagicTable[keys["6"]] = 10
  if options.z then
    MagicTable[keys["z"]] = 11
  else
    MagicTable[keys["y"]] = 11
  end
  MagicTable[keys["u"]] = 12
  MagicTable[keys["8"]] = 13
  MagicTable[keys["i"]] = 14
  MagicTable[keys["9"]] = 15
  MagicTable[keys["o"]] = 16
  MagicTable[keys["0"]] = 17
  MagicTable[keys["p"]] = 18
  if options.z then
    MagicTable[keys["y"]] = 19
  else
    MagicTable[keys["z"]] = 19
  end
  MagicTable[keys["s"]] = 20
  MagicTable[keys["x"]] = 21
  MagicTable[keys["d"]] = 22
  MagicTable[keys["c"]] = 23
  MagicTable[keys["v"]] = 24
  MagicTable[keys["g"]] = 25
end

if fs.exists("/usr/lib/noteal") and args[1] then
  --we have NoteAL!
  noteal = require("noteal.noteal")
  mode = "noteal"
elseif component.isAvailable("note_block") then
  --A note block is attached so go on with the stuff
  mode = "component"
  --some more stuff to make life easier
  noteb = component.note_block

else
  mode = "pc"
  print("Crappy-PC-Speaker fallback mode! No Noteblock detected!")
end

local function playNote(input)
  if mode == "noteal" then
    noteal.trigger(args[1],true,true,input)
  elseif mode == "component"  then
    noteb.trigger(input)
  elseif mode == "pc" then
    computer.beep(note.freq(note.ticks(input - 1)))
  end
end

if options.y then
  print("QWERTY-MODE activated")
elseif options.z then
  print("QWERTZ-MODE activated")
else
  print("OC-Piano 1.1 by Wuerfel_21\nPlease set your Keyboard-Layout:\npiano -y for QWERTY\npiano -z for QWERTZ\nIf you want to use NoteAL(sold seperatly) please give another argument containing the instrument name")
  return "why are you reading this?"
end

print("Keys from lowest pitch to highest pitch: 1, Q, 2, W, 3, E, R, 5, T, 6, Y(Z on QWERTZ-MODE!), U, 8, I, 9, O, 0, P, Z(Y on QWERTZ-MODE!), S, X, D, C, V, G \nIf this is too complicated: Minecraft Note Block studio has the same mapping(so try it out)")

MakeTheMagicHappen()
while 1 do
  local stuff,address,char,code,user = event.pull("key_down")
  if code == keys["c"] and keyboard.isControlDown() then
    return "good job"
  end
  if MagicTable[code] then
    if MagicTable[code] <= 25 and MagicTable[code] >=1 then
      playNote(MagicTable[code])
    end
  end
end