
local function get()
  local db = {}
  for l in io.lines("/etc/splashes") do
    table.insert(db,l)
  end
  local splash = db[math.random(1,#db)]
  db = nil
  return splash
end

return {get = get}