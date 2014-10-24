
local i

local function unpack(list)
  return table.unpack(list,1,list['n'])
end

local function remove(list,entry)
  if entry > list['n'] then return end
  local prevsize = list['n']
  list['n'] = list['n'] - 1
  for i=entry,list['n'] do
    list[i] = list[i+1]
  end
  list[prevsize] = nil
end

local function insert(list,entry,value)
  local prevsize = list['n']
  list['n'] = list['n'] + 1
  if entry <= prevsize then
    for i=list['n'],entry,-1 do
      list[i] = list[i-1]
    end
  end
  list[entry] = value
end

return {unpack=unpack,remove=remove,insert=insert}