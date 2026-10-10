local w,h = 1300,1300
local m1 = {vertexes = {},segments = {},colors = {}}
meshes = {m1}
local step = 100
for x = 0,w,step do
  local vc = #m1.vertexes
  m1.vertexes[vc+1] = {x,0}
  m1.vertexes[vc+2] = {x,h}
  m1.colors[vc+1] = 0xffffff32
  m1.colors[vc+2] = 0xffffff32
  table.insert(m1.segments,{vc,vc+1})
end
for y = 0,h,step do
  local vc = #m1.vertexes
  m1.vertexes[vc+1] = {0,y}
  m1.vertexes[vc+2] = {w,y}
  m1.colors[vc+1] = 0xffffff32
  m1.colors[vc+2] = 0xffffff32
  table.insert(m1.segments,{vc,vc+1})
end