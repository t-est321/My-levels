local width = 500fx
local height = 500fx
pewpew.set_level_size(width,height)

local bg_cubes = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg_cubes,"/dynamic/assets/background_cubes.lua",0)
pewpew.customizable_entity_start_spawning(bg_cubes,140)
pewpew.customizable_entity_configure_music_response(bg_cubes,{scale_z_start = 1fx,scale_z_end = 1fx+1fx/16fx})

local bg_lines = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg_lines,"/dynamic/assets/background_lines.lua",0)
pewpew.customizable_entity_start_spawning(bg_lines,140)
pewpew.customizable_entity_configure_music_response(bg_lines,{color_start = 0xffffff40,color_end = 0xffffffa0,scale_z_start = 1fx,scale_z_end = 2fx})

local bg_walls = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg_walls,"/dynamic/assets/background_walls.lua",0)
pewpew.customizable_entity_start_spawning(bg_walls,140)
pewpew.customizable_entity_configure_music_response(bg_walls,{scale_z_start = 1fx,scale_z_end = 1fx+1fx/2fx})

local ship = pewpew.new_player_ship(250fx,250fx,0)
pewpew.configure_player(0,{camera_distance = 50fx,shield = 3,shoot_joystick_color = 0})
pewpew.configure_player_ship_wall_trail(ship,{wall_length = 95})
pewpew.make_player_ship_transparent(ship,54)

pewpew.add_wall(0fx-1fx,400fx+1fx,100fx+1fx,500fx+1fx)
pewpew.add_wall(400fx-1fx,500fx+1fx,500fx+1fx,400fx-1fx)
pewpew.add_wall(400fx+1fx,0fx-1fx,500fx+1fx,100fx+1fx)
pewpew.add_wall(0fx-1fx,100fx+1fx,100fx+1fx,0fx-1fx)

local function random_position()
  return fmath.random_fixedpoint(50fx,450fx),fmath.random_fixedpoint(50fx,450fx)
end

for count = 1,46 do
  local x,y = random_position()
  local ra = fmath.random_fixedpoint(0fx,fmath.tau())
  pewpew.new_rolling_sphere(x,y,ra,3fx)
end

local time = 0
local fm_dz1 = 4fx
local fm_dz2 = 3fx+1fx/2fx
local fm_dz3 = 2fx+1fx/2fx
local fm_sc = 1fx
local fm_tbf = 75
local fm_op = false
pewpew.add_update_callback(function()
  time = time+1
  pewpew.increase_score_of_player(0,1)
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if pewpew.entity_get_is_alive(ship) then
    if time %150 == 0 then
      local x,y = random_position()
      local bs = fmath.random_int(2,7)
      local a = fmath.random_fixedpoint(0fx,fmath.tau())
      pewpew.new_rolling_sphere(x,y,a,3fx)
      pewpew.new_baf(x,y,a,8fx,75)
      pewpew.new_floating_message(x,y,"#ff3434ff+"..bs,{scale = fm_sc,dz = fm_dz1,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.new_floating_message(x,y,"#ff3434aa+"..bs,{scale = fm_sc,dz = fm_dz2,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.new_floating_message(x,y,"#ff343466+"..bs,{scale = fm_sc,dz = fm_dz3,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.increase_score_of_player(0,bs)
    end
    if time %900 == 0 then
      local x,y = random_position()
      local bs = fmath.random_int(7,15)
      pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
      pewpew.new_floating_message(x,y,"#ffff34ff+"..bs,{scale = fm_sc,dz = fm_dz1,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.new_floating_message(x,y,"#ffff34aa+"..bs,{scale = fm_sc,dz = fm_dz2,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.new_floating_message(x,y,"#ffff3466+"..bs,{scale = fm_sc,dz = fm_dz3,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.increase_score_of_player(0,bs)
    end
    if time %1300 == 0 then
      local x,y = random_position()
      local bs = fmath.random_int(25,65)
      pewpew.new_asteroid_with_size(x,y,1)
      for count = 1,8 do
        local a = fmath.random_fixedpoint(0fx,fmath.tau())
        pewpew.new_baf(x,y,a,9fx,300)
      end
      pewpew.new_floating_message(x,y,"#ffffffff+"..bs,{scale = fm_sc,dz = fm_dz1,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.new_floating_message(x,y,"#ffffffaa+"..bs,{scale = fm_sc,dz = fm_dz2,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.new_floating_message(x,y,"#ffffff66+"..bs,{scale = fm_sc,dz = fm_dz3,ticks_before_fade = fm_tbf,is_optional = fm_op})
      pewpew.increase_score_of_player(0,bs)
    end
  end
end)