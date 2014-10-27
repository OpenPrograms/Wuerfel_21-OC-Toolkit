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

local dispenser = require("dispenser")
local version,plugins,whome,wdata,wplugins

local function getSignal(signal,...)
  local args = table.pack(...)
  if signal == "init" then
    --We dont need a fancy init...
    version,plugins,whome,wdata,wplugins = ...
    return "std"
  elseif signal == "tell" then
    --This plugin dont needs to respond to tell signals...
    return "nop"
  elseif signal == "kill" then
    --We dont have anything to clean up, so just return nop
    return "nop"
  elseif signal == "request" then
    --Ohhh a request, nomnomnom
    if args[3] == "file" then
      --So sir, you want a file?
      local file,reason = io.open(wdata..args[4])
      if not file then return "print","std: ERROR while serving file request:",reason end
      local s = file:read("*all")
      file:close()
      return "answer",args[1],s
    else
      --Wut? No file?
      return "nop"
    end
  end
end

return getSignal