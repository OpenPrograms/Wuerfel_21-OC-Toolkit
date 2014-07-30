local noteal = require("noteal.noteal")

local function do_command(com)
  checkArg(1,com,"string")
  local val = {}
  local i = 1
  for v in string.gmatch(com, "%d+") do
    val[i] = tonumber(v)
    i=i+1
  end
  noteal.trigger(val[1],val[2],val[3],val[4])
  return val[5]
end

return {do_command = do_command}