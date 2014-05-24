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

local confutil = require("noteal.confutil")
local component = require("component")

local target

local blocks = assert(confutil.rcon("noteal"),"No config found")
for k,v in pairs(blocks) do
v.left = component.proxy(v.left)
v.right = component.proxy(v.right)
end

local function trigger(instrument,left,right,note)
checkArg(1,instrument,"string","number")
checkArg(2,left,"boolean")
checkArg(3,right,"boolean")
checkArg(4,note,"number")
if instrument == 0 or instrument == "piano" then target = blocks.piano
elseif instrument == 1 or instrument == "bass" then target = blocks.bass
elseif instrument == 2 or instrument == "drum" then target = blocks.drum 
elseif instrument == 3 or instrument == "snare" then target = blocks.snare
elseif instrument == 4 or instrument == "click" then target = blocks.click
else error("invalid instrument")
end
if left then target.left.trigger(note) end
if right then target.right.trigger(note) end
end

return {
confutil = confutil,
trigger = trigger
}