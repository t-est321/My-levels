local gfx = require("/dynamic/graphics_helpers.lua")
local w = 1000
local h = 1000
function make_level_mesh()
  local mesh = gfx.new_mesh()
  local color = gfx.make_color(205, 255, 255, 255)
  local rad = 50
  for x = 1, (w / 50) - 1 do
    for y = 1, (h / 50) - 1 do
      if (x + y) % 2 == 0 then
        gfx.add_line_to_mesh(mesh, {{x * 50 - rad, y * 50, 0}, {x * 50 + rad, y * 50, 0}}, {color, color})
        gfx.add_line_to_mesh(mesh, {{x * 50, y * 50 - rad, 0}, {x * 50, y * 50 + rad, 0}}, {color, color})
      end
    end
  end
  return mesh
end
meshes = {make_level_mesh()}