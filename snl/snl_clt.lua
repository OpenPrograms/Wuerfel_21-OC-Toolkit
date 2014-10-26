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
