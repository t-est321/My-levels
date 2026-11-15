computed_vertexes = {}
computed_segments = {}
computed_colors = {}
local index1 = 0
local index2 = 1
local index3 = 2
local index4 = 3
for i=0,50 do
  local x = math.random(0,1000)
  local y = math.random(0,1000)
  table.insert(computed_vertexes,{x-1,y-1,0})
  table.insert(computed_vertexes,{x-1,y+1,0})
  table.insert(computed_vertexes,{x+1,y+1,0})
  table.insert(computed_vertexes,{x+1,y-1,0})
  table.insert(computed_segments,{index1,index2,index3,index4,index1})
  index1 = index1 + 4
  index2 = index2 + 4
  index3 = index3 + 4
  index4 = index4 + 4
  table.insert(computed_colors,0x0088ffaa)
  table.insert(computed_colors,0x0088ddaa)
  table.insert(computed_colors,0x0088bbaa)
  table.insert(computed_colors,0x0088ddaa)
end
for i=0,256 do
  local x = math.random(0,1000)
  local y = math.random(0,1000)
  local z = math.random(-600,-15)
  table.insert(computed_vertexes,{x-1,y-1,z})
  table.insert(computed_vertexes,{x-1,y+1,z})
  table.insert(computed_vertexes,{x+1,y+1,z})
  table.insert(computed_vertexes,{x+1,y-1,z})
  table.insert(computed_segments,{index1,index2,index3,index4,index1})
  index1 = index1 + 4
  index2 = index2 + 4
  index3 = index3 + 4
  index4 = index4 + 4
  table.insert(computed_colors,0x98ca66cc)
  table.insert(computed_colors,0xafcd82cc)
  table.insert(computed_colors,0x98ca66cc)
  table.insert(computed_colors,0xafcd82cc)
end
meshes = {
  {
    vertexes = computed_vertexes,
    segments = computed_segments,
    colors = computed_colors
  }
}