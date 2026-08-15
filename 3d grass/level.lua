local width = 1000fx
local height = 1000fx
pewpew.set_level_size(width,height)
require("/dynamic/enemies/boseld/boseld.lua")
require("/dynamic/enemies/bosore/bosore.lua")
require("/dynamic/logics/ufo.lua")
require("/dynamic/logics/shield_spawn_with_particles.lua")
require("/dynamic/logics/particles_at_level.lua")

local ground = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(ground,"/dynamic/assets/background.lua",0)
local ground2 = pewpew.new_customizable_entity(-100fx,-100fx)
pewpew.customizable_entity_set_mesh(ground2,"/dynamic/assets/background_2.lua",0)
pewpew.customizable_entity_set_mesh_xyz_scale(ground2,1fx,1fx,1fx/2fx)
local ground3 = pewpew.new_customizable_entity(-200fx,-200fx)
pewpew.customizable_entity_set_mesh(ground3,"/dynamic/assets/background_3.lua",0)
pewpew.customizable_entity_set_mesh_xyz_scale(ground3,1fx,1fx,1fx/3fx)
local bg = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg,"/dynamic/level_graphics.lua",0)

local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end

pewpew.configure_player(0,{shield = 2,camera_distance = -85fx,camera_rotation_x_axis = fmath.tau()/-28fx})
local ship = pewpew.new_player_ship(width/8fx,height/8fx,0)
pewpew.set_player_ship_speed(ship,1fx,1fx/4fx-1fx,-1)
pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.TIC_TOC})
pewpew.configure_player(0,{move_joystick_color = 0x23ff23b0,shoot_joystick_color = 0x23ff23b0})

pewpew.customizable_entity_start_spawning(ground,93)
pewpew.customizable_entity_start_spawning(ground2,97)
pewpew.customizable_entity_start_spawning(ground3,101)
pewpew.customizable_entity_start_spawning(bg,124)

pewpew.customizable_entity_configure_music_response(ground,{scale_z_start = 1fx,scale_z_end = 2fx})
pewpew.customizable_entity_configure_music_response(ground2,{scale_z_start = 1fx,scale_z_end = 2fx})
pewpew.customizable_entity_configure_music_response(ground3,{scale_z_start = 1fx,scale_z_end = 2fx})

local time = 0

local x,y = random_position()
pewpew.add_arrow_to_player_ship(ship,pewpew.new_bomb(x,y,pewpew.BombType.REPULSIVE),0xff2500b0)

pewpew.add_update_callback(function()
  time = time+1
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if pewpew.entity_get_is_alive(ship) then
    level_particles(0fx,1000fx,0fx,1000fx,50fx,fmath.random_fixedpoint(-2fx,2fx),fmath.random_fixedpoint(-2fx,2fx),fmath.random_fixedpoint(-2fx,2fx),0x00ff00ff,0x00ff00cc,57,1)
    if time%17 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1192)
    end
    if time%29 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),7fx,1192)
    end
    if time%47 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),7fx,1192)
    end
    if time%276 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid_with_size(x,y,2)
    end
    if time%350 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
      local x2,y2 = random_position()
      pewpew.new_crowder(x2,y2)
    end
    if time%475 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_cube(x,y)
      local x2,y2 = random_position()
      pewpew.new_rolling_sphere(x2,y2,fmath.random_fixedpoint(0fx,fmath.tau()),5fx)
    end
    if time%825 == 0 then
      local x,y = random_position()
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if time%1000 == 0 then
      local x,y = 500fx+fmath.random_fixedpoint(-45fx,45fx),500fx+fmath.random_fixedpoint(-45fx,45fx)
      boseld_new(x,y)
      for count = 1,8 do
        pewpew.new_brownian(x,y)
      end
    end
    if time%1650 == 0 then
      local x,y = random_position()
      shield_spawn(x,y,25,0xffff00ee,1,420)
    end
    if time%700 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.SIX_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      local x2,y2 = random_position()
      bosore_new(x2,y2)
      for count = 1,12 do
        pewpew.new_asteroid_with_size(x2+fmath.random_fixedpoint(-5fx,5fx),y2+fmath.random_fixedpoint(-5fx,5fx),0)
      end
    end
    if time%2650 == 0 then
      local x,y = random_position()
      add_ufo(x,y,3fx,true)
    end
    if time%2000 == 0 then
      local x,y = random_position()
      pewpew.new_bonus(x,y,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.TRIPLE,frequency = pewpew.CannonFrequency.FREQ_30,box_duration = 420,weapon_duration = 45})
      local x,y = random_position()
      pewpew.add_arrow_to_player_ship(ship,pewpew.new_bomb(x,y,pewpew.BombType.REPULSIVE),0xff2500b0)
    end

    if time == 1500 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_floating_message(x,y,"BOSS",{scale = 1fx,ticks_before_fade = 60,is_optional = false})
    end
    if time == 3500 then
      local px,py = pewpew.entity_get_position(ship)
      pewpew.new_floating_message(px,py,"#ff0000ffPHASE 2",{scale = 1fx,ticks_before_fade = 90,is_optional = false})
      pewpew.set_player_ship_speed(ship,1fx,1fx/2fx+1fx,-1)
    end
    if time == 4500 then
      local x,y = random_position()
      pewpew.new_smothership(x,y,pewpew.MothershipType.SIX_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_floating_message(x,y,"BOSS",{scale = 1fx,ticks_before_fade = 60,is_optional = false})
      for count = 1,15 do
        pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),3fx)
      end
    end
    if time == 6000 then
      for count = 1,5 do
        local x,y = random_position()
        pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
    end
    if time == 7000 then
      local px,py = pewpew.entity_get_position(ship)
      pewpew.new_floating_message(px,py,"#ff00ffffPHASE 3",{scale = 1fx,ticks_before_fade = 90,is_optional = false})
    end
    if time == 9000 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      local x2,y2 = random_position()
      for count = 1,6 do
        pewpew.new_kamikaze(x2,y2,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
      pewpew.new_floating_message(width/2fx,height/2fx,"DOUBLE BOSS",{scale = 1fx,ticks_before_fade = 90,is_optional = false})
    end
    if time == 10500 then
      local px,py = pewpew.entity_get_position(ship)
      pewpew.new_floating_message(px,py,"#00ff00ffPHASE 4",{scale = 1fx,ticks_before_fade = 90,is_optional = false})
    end

    if time >= 3500 and time < 7000 then
      if time%160 == 0 then
        local x,y = random_position()
        pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
      if time%200 == 0 then
        local x,y = random_position()
        pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
      end
    end

    if time >= 7000 and time < 10500 then
      if time%100 == 0 then
        local x,y = random_position()
        pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
      if time%180 == 0 then
        local x,y = random_position()
        pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),7fx)
      end
      if time%300 == 0 then
        local x,y = random_position()
        add_ufo(x,y,4fx,true)
      end
    end

    if time >= 10500 then
      if time%60 == 0 then
        local x,y = random_position()
        pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
      if time%90 == 0 then
        local x,y = random_position()
        pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),3fx)
      end
    end
  end
end)