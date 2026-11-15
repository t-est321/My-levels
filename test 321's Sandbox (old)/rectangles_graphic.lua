computed_vertexes = {}
computed_segments = {}
computed_colors = {}

local colors = {
  0xf40c3aff,
  0xf4e10cff,
  0xff6600ff,
  0x00ccffff,
  0x00ff00ff,
  0xff00ffff,
  0xffffffff,
  0x0000ffff,
  0xff9900ff,
  0x00ff99ff,
  0x9900ffff,
  0xff0099ff
}

local color_a = colors[math.random(1,#colors)]
local color_b
repeat
  color_b = colors[math.random(1,#colors)]
until color_b ~= color_a

local index1 = 0
local index2 = 1
local index3 = 2
local index4 = 3
local toggle = true

for z = -1200,600,55 do
  local width = 1000+fmath.random_int(-15,15)
  local height = 1000+fmath.random_int(-15,15)
  local a = 0+fmath.random_int(-15,15)
  table.insert(computed_vertexes,{a,a,z})
  table.insert(computed_vertexes,{width,a,z})
  table.insert(computed_vertexes,{width,height,z})
  table.insert(computed_vertexes,{a,height,z})
  table.insert(computed_segments,{index1,index2,index3,index4,index1})
  index1 = index1+4
  index2 = index2+4
  index3 = index3+4
  index4 = index4+4
  local c = toggle and color_a or color_b
  toggle = not toggle
  table.insert(computed_colors,c)
  table.insert(computed_colors,c)
  table.insert(computed_colors,c)
  table.insert(computed_colors,c)
end

meshes = {{
  vertexes = computed_vertexes,
  segments = computed_segments,
  colors = computed_colors
}}