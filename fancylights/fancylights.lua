local component = require("component")
local event = require("event")
local keyboard = require("keyboard")
local shell = require("shell")

local args,options = shell.parse(...)

local redstone = options.r
local lightness = 0.25
local hue = math.random()

local function setAllLamps(color)
  for a,t in component.list("colorful_lamp") do
    component.proxy(a).setLampColor(color)
  end
end

local function encode(r,g,b)
  tmp = r
  tmp = bit32.bor(tmp,bit32.lshift(g,5))
  tmp = bit32.bor(tmp,bit32.lshift(b,10))
  return tmp
end

--Stolen from https://github.com/EmmanuelOga/columns/blob/master/utils/color.lua
local function hslToRgb(h, s, l)
  local r, g, b

  if s == 0 then
    r, g, b = l, l, l -- achromatic
  else
    local function hue2rgb(p, q, t)
      if t < 0   then t = t + 1 end
      if t > 1   then t = t - 1 end
      if t < 1/6 then return p + (q - p) * 6 * t end
      if t < 1/2 then return q end
      if t < 2/3 then return p + (q - p) * (2/3 - t) * 6 end
      return p
    end

    local q
    if l < 0.5 then q = l * (1 + s) else q = l + s - l * s end
    local p = 2 * l - q

    r = hue2rgb(p, q, h + 1/3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1/3)
  end

  return r * 31, g * 31, b * 31
end

local function handler()
  if redstone then
    if component.redstone.getInput(1) ~= 0 then
      lightness = lightness + 0.02
    else
      lightness = lightness - 0.02
    end
    if lightness > 0.5 then lightness = 0.5 end
    if lightness < 0 then lightness = 0 end
  else
    lightness = 0.5
  end
  setAllLamps(encode(hslToRgb(hue,1,lightness)))
  hue = (hue+0.005)%1
end

if _G.fancylightsID then event.cancel(_G.fancylightsID) end
if options.c then
  setAllLamps(0)
  print("FancyLights stopped!")
  return
end

_G.fancylightsID = event.timer(0.5,handler,math.huge)
print("FancyLights loaded!")