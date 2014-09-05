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