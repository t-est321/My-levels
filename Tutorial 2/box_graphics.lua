local gfx = require("/dynamic/graphics_helpers.lua")
meshes = {gfx.new_mesh(), gfx.new_mesh()}
gfx.add_cube_to_mesh(meshes[1], {0, 0, 15}, 30, 0x00ffffff)