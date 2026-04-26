local gfx = require("/dynamic/graphics_helpers.lua")
local w = 750
local h = 750
function make_level_mesh()
  local mesh = gfx.new_mesh()
  local color = gfx.make_color(255, 255, 255, 255)
  local radius = 15
  for x = 1, (w / 50) - 1 do
    for y = 1, (h / 50) - 1 do
      if (x + y) % 2 == 0 then
        gfx.add_line_to_mesh(mesh, {{x * 50 - radius, y * 50, 0}, {x * 50 + radius, y * 50, 0}}, {color, color})
        gfx.add_line_to_mesh(mesh, {{x * 50, y * 50 - radius, 0}, {x * 50, y * 50 + radius, 0}}, {color, color})
      end
    end
  end
  return mesh
end
meshes = {make_level_mesh()}