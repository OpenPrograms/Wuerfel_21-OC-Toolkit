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

local confutil = require("noteal.confutil")
local component = require("component")

local target

local blocks = assert(confutil.rcon("noteal"),"No config found")
if blocks.computronics then
blocks.left = component.proxy(blocks.left)
blocks.right = component.proxy(blocks.right)
else
for k,v in pairs(blocks) do
v.left = component.proxy(v.left)
v.right = component.proxy(v.right)
end
end

local function triggercomputronics(instrument,left,right,note)
checkArg(1,instrument,"string","number")
checkArg(2,left,"boolean","number")
checkArg(3,right,"boolean","number")
checkArg(4,note,"number")
if instrument == "piano" then instrument = 0
elseif instrument == "drum" then instrument = 1
elseif instrument == "snare" then instrument = 2
elseif instrument == "click" then instrument = 3
elseif instrument == "bass" then instrument = 4
elseif instrument == "pling" then instrument = 5
elseif instrument == "bass2" then instrument = 6
end
if left then blocks.left.playNote(instrument,note -1) end
if right then blocks.right.playNote(instrument,note -1) end
end

local function triggervanilla(instrument,left,right,note)
checkArg(1,instrument,"string","number")
checkArg(2,left,"boolean")
checkArg(3,right,"boolean")
checkArg(4,note,"number")
if instrument == 0 or instrument == "piano" then target = blocks.piano
elseif instrument == 1 or instrument == "drum" then target = blocks.bass
elseif instrument == 2 or instrument == "snare" then target = blocks.drum 
elseif instrument == 3 or instrument == "click" then target = blocks.snare
elseif instrument == 4 or instrument == "bass" then target = blocks.click
elseif instrument == 5 or instrument == "pling" then target = blocks.piano
elseif instrument == 6 or instrument == "bass2" then target = blocks.bass
else error("invalid instrument")
end
if left == true or left == 1 then target.left.trigger(note) end
if right == true or right == 1 then target.right.trigger(note) end
end

local function trigger(instrument,left,right,note)
if blocks.computronics then
triggercomputronics(instrument,left,right,note)
else
triggervanilla(instrument,left,right,note)
end
end

return {
confutil = confutil,
trigger = trigger
}