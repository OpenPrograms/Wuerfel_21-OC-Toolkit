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