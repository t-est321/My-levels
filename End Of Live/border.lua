local sides = 40
local r = 100
local h = 20
local vertexes = {}
local segments = {}
for i = 0,sides-1 do
  local a = i*math.pi*2/sides
  local c = math.cos(a)*r
  local s = math.sin(a)*r
  table.insert(vertexes,{c,s,h})
  table.insert(vertexes,{c,s,-h})
end
for i = 0,sides-1 do
  local top_curr = i*2
  local bot_curr = i*2+1
  local top_next = ((i+1)%sides)*2
  local bot_next = ((i+1)%sides)*2+1
  table.insert(segments,{top_curr,top_next})
  table.insert(segments,{bot_curr,bot_next})
  table.insert(segments,{top_curr,bot_curr})
end
meshes = {{
  vertexes = vertexes,
  segments = segments
}}