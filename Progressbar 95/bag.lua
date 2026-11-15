local C = require("/dynamic/game_config.lua")
local R = require("/dynamic/rng.lua")

local bag = {}

local BAG_SIZE = 40
local KEYS = {"blue","cyan","yellow","red","pink","gray","green","random"}

local function shuffle(list)
  for i = #list,2,-1 do
    local j = R.int(1,i)
    local value = list[i]
    list[i] = list[j]
    list[j] = value
  end
  return list
end

local function kind_of(key)
  if key == "cyan" then
    if R.chance(30) then
      return C.CYAN3
    end
    return C.CYAN2
  elseif key == "yellow" then
    return C.YELLOW
  elseif key == "red" then
    return C.RED
  elseif key == "pink" then
    return C.PINK
  elseif key == "gray" then
    return C.GRAY
  elseif key == "green" then
    return C.GREEN
  elseif key == "random" then
    return C.RANDOM
  end
  return C.BLUE
end

local function key_for_kind(kind)
  if kind == C.CYAN2 or kind == C.CYAN3 then
    return "cyan"
  elseif kind == C.YELLOW then
    return "yellow"
  elseif kind == C.RED then
    return "red"
  elseif kind == C.PINK then
    return "pink"
  elseif kind == C.GRAY then
    return "gray"
  elseif kind == C.GREEN then
    return "green"
  elseif kind == C.RANDOM then
    return "random"
  end
  return "blue"
end

local function apportion(weights,total)
  local counts = {}
  local entries = {}
  local assigned = 0
  for i = 1,#KEYS do
    local key = KEYS[i]
    local weight = weights[key]
    counts[key] = 0
    if weight > 0 then
      local exact = weight*BAG_SIZE
      local base = exact//total
      counts[key] = base
      assigned = assigned+base
      entries[#entries+1] = {key = key,rem = exact-base*total,weight = weight,used = false}
    end
  end
  for i = 1,#entries do
    local key = entries[i].key
    if counts[key] == 0 then
      counts[key] = 1
      assigned = assigned+1
    end
  end
  while assigned > BAG_SIZE do
    local pick = nil
    for i = 1,#entries do
      local key = entries[i].key
      if counts[key] > 1 then
        if pick == nil or counts[key] > counts[pick] then
          pick = key
        end
      end
    end
    if pick == nil then
      break
    end
    counts[pick] = counts[pick]-1
    assigned = assigned-1
  end
  while assigned < BAG_SIZE and #entries > 0 do
    local best = nil
    for i = 1,#entries do
      if not entries[i].used then
        if best == nil then
          best = i
        else
          local a = entries[i]
          local b = entries[best]
          if a.rem > b.rem or (a.rem == b.rem and a.weight > b.weight) then
            best = i
          end
        end
      end
    end
    if best == nil then
      for i = 1,#entries do
        entries[i].used = false
      end
    else
      entries[best].used = true
      local key = entries[best].key
      counts[key] = counts[key]+1
      assigned = assigned+1
    end
  end
  return counts
end

local function refill(target)
  local weights = target.weights
  local total = 0
  for i = 1,#KEYS do
    total = total+weights[KEYS[i]]
  end
  local list = {}
  if total <= 0 then
    for i = 1,BAG_SIZE do
      list[i] = "blue"
    end
    return list
  end
  local counts = apportion(weights,total)
  for i = 1,#KEYS do
    local key = KEYS[i]
    for _ = 1,counts[key] do
      list[#list+1] = key
    end
  end
  shuffle(list)
  for pass = 1,12 do
    for i = 2,#list do
      local a = list[i-1]
      local b = list[i]
      if a == b and (a == "red" or a == "green" or a == "random") then
        local prev = nil
        if i >= 3 then
          prev = list[i-2]
        end
        for j = 1,#list do
          local c = list[j]
          if c ~= a and c ~= prev then
            local value = list[i]
            list[i] = list[j]
            list[j] = value
            break
          end
        end
      end
    end
    for i = 1,3 do
      if list[i] == "red" then
        for j = 4,#list do
          if list[j] ~= "red" then
            local value = list[i]
            list[i] = list[j]
            list[j] = value
            break
          end
        end
      end
    end
  end
  if weights.blue > 0 then
    local blues = 0
    for i = 1,#list do
      if list[i] == "blue" then
        blues = blues+1
      end
    end
    if blues < 6 then
      local swapped = 0
      for i = 1,#list do
        if swapped >= 6-blues then
          break
        end
        if list[i] ~= "blue" and list[i] ~= "red" then
          list[i] = "blue"
          swapped = swapped+1
        end
      end
    end
  end
  return list
end

local function signature(target)
  local weights = target.weights
  local parts = {}
  for i = 1,#KEYS do
    parts[i] = tostring(weights[KEYS[i]])
  end
  return table.concat(parts,",")
end

function bag.reset(target)
  bag.list = refill(target)
  bag.index = 1
  bag.streak = 0
  bag.shuffles = 1
  bag.mark = signature(target)
end

function bag.next(target)
  local mark = signature(target)
  if bag.list == nil or mark ~= bag.mark then
    bag.reset(target)
  end
  if bag.index > #bag.list then
    bag.list = refill(target)
    bag.index = 1
    bag.shuffles = bag.shuffles+1
  end
  local key = bag.list[bag.index]
  bag.index = bag.index+1
  if bag.streak >= 5 and target.weights.blue > 0 then
    key = "blue"
    bag.streak = 0
  end
  if key == "blue" then
    bag.streak = 0
  else
    bag.streak = bag.streak+1
  end
  return kind_of(key),key
end

function bag.length()
  if bag.list == nil then
    return 0
  end
  return #bag.list
end

function bag.remaining()
  if bag.list == nil then
    return 0
  end
  return #bag.list-bag.index+1
end

function bag.key_of(kind)
  return key_for_kind(kind)
end

return bag
