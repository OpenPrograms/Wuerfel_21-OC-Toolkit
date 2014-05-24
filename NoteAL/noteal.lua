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