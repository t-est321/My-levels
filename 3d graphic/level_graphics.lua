local gfx = require("/dynamic/graphics_helpers.lua")
local w = 1000
local h = 1000
function make_level_mesh()
  local mesh = gfx.new_mesh()
  local color = gfx.make_color(130, 150, 150, 100)
  for x = -4, (w/7) do
    for y = -4, (h/7) do
      if (x + y) %2 == 0 then
        local rz = fmath.random_int(15,175)
        gfx.add_line_to_mesh(mesh, {{x*7, y*7, 0}, {x*7, y*7, rz}}, {color, color})
      end
    end
  end
  return mesh
end
meshes = {make_level_mesh()}