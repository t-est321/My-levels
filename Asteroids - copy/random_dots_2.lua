computed_vertexes = {}
computed_segments = {}
computed_colors = {}
local index1 = 0
local index2 = 1
local index3 = 2
local index4 = 3
for i=0,760 do
  local x = math.random(-1268,1268)
  local y = math.random(-684,684)
  local z = math.random(-375,-10)
  table.insert(computed_vertexes,{x-0.125,y-0.125,z})
  table.insert(computed_vertexes,{x-0.125,y+0.125,z})
  table.insert(computed_vertexes,{x+0.125,y+0.125,z})
  table.insert(computed_vertexes,{x+0.125,y-0.125,z})
  table.insert(computed_segments,{index1,index2,index3,index4,index1})
  index1 = index1+4
  index2 = index2+4
  index3 = index3+4
  index4 = index4+4
  table.insert(computed_colors,0xffffff35)
  table.insert(computed_colors,0xffffff35)
  table.insert(computed_colors,0xffffff35)
  table.insert(computed_colors,0xffffff35)
end
meshes = {{
    vertexes = computed_vertexes,
    segments = computed_segments,
    colors = computed_colors
}}