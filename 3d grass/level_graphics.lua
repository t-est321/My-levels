local gfx = require("/dynamic/graphics_helpers.lua")
local w = 1000
local h = 1000
function level_mesh()
  local mesh = gfx.new_mesh()
  for x = 0,(w/7) do
    for y = 0,(h/7) do
      if (x+y)%2 == 0 then
        local rz = fmath.random_int(5,50)
        local rx = fmath.random_int(1,12)
        local ry = fmath.random_int(1,12) 
        local rx2 = fmath.random_int(1,12) 
        local ry2 = fmath.random_int(1,12)
        gfx.add_line_to_mesh(mesh,{{x*7+rx,y*7+ry},{x*7+rx2,y*7+ry2,rz}},{0x00ff0042,0x00ff0042})
      end
    end
  end
  return mesh
end
meshes = {level_mesh()}