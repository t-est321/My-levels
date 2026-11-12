local size = 800
local step = 100
local vertexes = {}
local colors = {}
local segments = {}
local index = 0
for i = 0,8 do
  local p = i*step
  vertexes[index+1] = {p,0}
  vertexes[index+2] = {p,size}
  colors[index+1] = 0x1a2a4aff
  colors[index+2] = 0x1a2a4aff
  segments[#segments+1] = {index,index+1}
  index = index+2
  vertexes[index+1] = {0,p}
  vertexes[index+2] = {size,p}
  colors[index+1] = 0x1a2a4aff
  colors[index+2] = 0x1a2a4aff
  segments[#segments+1] = {index,index+1}
  index = index+2
end
local border_vertexes = {{0,0},{size,0},{size,size},{0,size}}
local border_colors = {0x3a5a9aff,0x3a5a9aff,0x3a5a9aff,0x3a5a9aff}
meshes = {
  {
    vertexes = vertexes,
    colors = colors,
    segments = segments
  },
  {
    vertexes = border_vertexes,
    colors = border_colors,
    segments = {{0,1,2,3,0}}
  }
}
