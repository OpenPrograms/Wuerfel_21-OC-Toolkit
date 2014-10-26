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
if left == true or left == 1 then blocks.left.playNote(instrument,note -1) end
if right == true or right == 1 then blocks.right.playNote(instrument,note -1) end
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