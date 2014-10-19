--Copyright (C) 2014  Wuerfel_21
--
--This program is free software; you can redistribute it and/or
--modify it under the terms of the GNU Lesser General Public
--License as published by the Free Software Foundation; either
--version 2.1 of the License, or (at your option) any later version.

--This program is distributed in the hope that it will be useful,
--but WITHOUT ANY WARRANTY; without even the implied warranty of
--MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
--Lesser General Public License for more details.

--You should have received a copy of the GNU Lesser General Public
--License along with this lprogram; if not, write to the Free Software
--Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA

local component = require("component")
local computer = require("computer")
local event = require("event")

local modem = component.modem

local function getservice(hostname,service)
  modem.open(9261)
  local signal = {}
  local timeout = computer.uptime() + 70
  modem.broadcast(9261,hostname,service)
  repeat
    if timeout < computer.uptime() then modem.close(9261) return nil,nil end
    signal = table.pack(computer.pullSignal(timeout-computer.uptime()))
    if signal[1] == "modem_message" and signal[4] == 9261 then
      modem.close(9261)
      return signal[6],signal[7]
    else
      computer.pushSignal(table.unpack(signal))
    end
  until table.unpack(signal) == nil
  modem.close(9261)
end

return {getservice = getservice}
