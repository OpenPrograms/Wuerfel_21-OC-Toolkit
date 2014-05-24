local confutil = require("noteal.confutil")
local component = require("component")
print("Welcome to noteconf the NoteAL configuration tool!")
print("NoteAL version "..confutil.version.." enabled!")
print("Enter (short) adress of the noteblock you want to assign, leave blank if you dont have this noteblock")
local conf = confutil.rcon("noteal")
local valid = false
local foo
local bar

if not conf then
conf = {
piano = {left = "",right = ""},
bass = {left = "",right = ""},
drum = {left = "",right = ""},
snare = {left = "",right = ""},
click = {left = "",right = ""}
}
end

while not valid do
print("left piano:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.piano.left = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("right piano:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.piano.right = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("left bass:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.bass.left = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("right bass:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.bass.right = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("left drum:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.drum.left = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("right drum:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.drum.right = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("left snare:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.snare.left = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("right snare:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.snare.right = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("left click:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.click.left = foo
valid = true
end
else
print(bar)
end
end
valid = false

while not valid do
print("right click:")
local foo = io.read()
foo,bar = component.get(foo,"note_block")
if foo then
if component.proxy(foo).trigger(13) then
conf.click.right = foo
valid = true
end
else
print(bar)
end
end
valid = false

confutil.wcon("noteal",conf)
print("Completed!")