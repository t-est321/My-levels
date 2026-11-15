local rng = {}

local seed_state = 2463534242

local function mix(value)
  local x = (value*1103515245+12345)&0x7fffffff
  x = (x ~ (x*0x2000&0x7fffffff))&0x7fffffff
  x = (x*69069+1)&0x7fffffff
  seed_state = x
  return x
end

function rng.seed(value)
  local start = (value*2654435761+1013904223)&0xffffffff
  if start == 0 then
    start = 2463534242
  end
  seed_state = start
  for i = 1,4 do
    mix(seed_state)
  end
end

function rng.value()
  return mix(seed_state)
end

function rng.int(low,high)
  if high <= low then
    return low
  end
  return low+(rng.value()%(high-low+1))
end

function rng.unit()
  return rng.value()%4096
end

function rng.fx(low,high)
  return low+fmath.from_fraction((high-low)*rng.unit(),4096)
end

function rng.chance(percent)
  return (rng.value()%100) < percent
end

function rng.pick(table_of_values)
  local count = #table_of_values
  if count <= 0 then
    return nil
  end
  return table_of_values[rng.int(1,count)]
end

return rng
