local fs = require("filesystem")
for f in fs.list("/init") do
  dofile("/init/"..f)
end