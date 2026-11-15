local width = 1000fx
local height = 1000fx
pewpew.set_level_size(width,height)
local bg = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg,"/dynamic/level_graphics.lua",0)
local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end
pewpew.configure_player(0,{shield = 3,camera_distance = 200fx,camera_rotation_x_axis = fmath.tau() / -7fx})
local ship = pewpew.new_player_ship(width / 8fx,height / 8fx,0)
pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.TIC_TOC})
function clamp(v,min,max)
  return v
end
local time = 0

local cube = pewpew.new_customizable_entity(100fx,100fx)
pewpew.customizable_entity_set_mesh(cube,"/dynamic/3d_cube.lua",0)
pewpew.customizable_entity_set_mesh_angle(cube,fmath.tau() / -2fx,7fx,5fx,8fx)
pewpew.entity_set_update_callback(cube,function(entity_id)
  pewpew.customizable_entity_add_rotation_to_mesh(entity_id,0.200fx,1fx,0fx,0fx)
  pewpew.customizable_entity_add_rotation_to_mesh(entity_id,0.400fx,0fx,0.6fx,0fx)
end)

pewpew.add_update_callback(function()
  time = time + 1
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if time %7 == 0 then
    local x,y = random_position()
    pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1452)
  end
  if time %65 == 0 then
    local x,y = random_position()
    pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1452)
  end
  if time %35 == 0 then
    local x,y = random_position()
    pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1452)
  end
  if time %3090 == 0 then
    local x,y = random_position()
    pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
  end
end)