local star_v = {}
local star_s = {}
local star_c = {}
local sides = 16
for i = 0,sides-1 do
  local a = i*math.pi*2/sides
  local x1 = math.cos(a)*20
  local y1 = math.sin(a)*20
  local x2 = math.cos(a+math.pi/sides)*65
  local y2 = math.sin(a+math.pi/sides)*65
  table.insert(star_v,{x1,y1})
  table.insert(star_v,{x2,y2})
  if i%2 == 0 then
    table.insert(star_c,0xff00ffee)
    table.insert(star_c,0x00ffffee)
  else
    table.insert(star_c,0x9900ffff)
    table.insert(star_c,0x22ffffff)
  end
end
local seg = {}
for i = 0,sides*2-1 do
  table.insert(seg,i)
end
table.insert(seg,0)
table.insert(star_s,seg)

local ring_v = {}
local ring_s = {{}}
local ring_c = {}
local ring_sides = 24
for i = 0,ring_sides do
  local a = i*math.pi*2/ring_sides
  table.insert(ring_v,{math.cos(a)*110,math.sin(a)*110})
  table.insert(ring_s[1],i)
  if i%2 == 0 then
    table.insert(ring_c,0x12ffffdd)
  else
    table.insert(ring_c,0x0055ffbb)
  end
end

meshes = {{
  vertexes = star_v,
  colors = star_c,
  segments = star_s
},{
  vertexes = ring_v,
  colors = ring_c,
  segments = ring_s
}}
