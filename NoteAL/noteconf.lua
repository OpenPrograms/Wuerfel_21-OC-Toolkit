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
local shell = require("shell")
print("Welcome to noteconf the NoteAL configuration tool!")
print("NoteAL version "..confutil.version.." enabled!")
print("Enter (short) adress of the noteblock you want to assign")
local conf = confutil.rcon("noteal")
local args,options = shell.parse(...)
local valid = false
local foo
local bar

if options.c then
conf = {computronics = true,left = "",right = ""}

while not valid do
print("left:")
local foo = io.read()
foo,bar = component.get(foo,"iron_noteblock")
if foo then
component.proxy(foo).playNote(5,12)
conf.left = foo
valid = true
else
print(bar)
end
end
valid = false

while not valid do
print("right:")
local foo = io.read()
foo,bar = component.get(foo,"iron_noteblock")
if foo then
component.proxy(foo).playNote(5,12)
conf.right = foo
valid = true
else
print(bar)
end
end
valid = false

confutil.wcon("noteal",conf)
print("Completed!")
else
conf = {
computronics = true,
piano = {left = "",right = ""},
bass = {left = "",right = ""},
drum = {left = "",right = ""},
snare = {left = "",right = ""},
click = {left = "",right = ""}
}

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
end