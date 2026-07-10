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
local ground3 = pewpew.new_customizable_entity(-200fx,-200fx)
pewpew.customizable_entity_set_mesh(ground3,"/dynamic/assets/background_3.lua",0)
local bg = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg,"/dynamic/level_graphics.lua",0)

local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end

pewpew.configure_player(0,{shield = 3,camera_rotation_x_axis = fmath.tau()/-28fx})
local ship = pewpew.new_player_ship(width/8fx,height/8fx,0)
pewpew.set_player_ship_speed(ship,1fx,1fx/2fx+1fx,-1)
pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.TIC_TOC})
pewpew.configure_player(0,{move_joystick_color = 0x23ff23b0,shoot_joystick_color = 0x23ff23b0})

pewpew.customizable_entity_start_spawning(ground,93)
pewpew.customizable_entity_start_spawning(ground2,97)
pewpew.customizable_entity_start_spawning(ground3,101)
pewpew.customizable_entity_start_spawning(bg,124)

pewpew.customizable_entity_configure_music_response(ground,{scale_z_start = 1fx,scale_z_end = 2fx,startColor = 0x00ff0023,endColor = 0x00ff00a0})
pewpew.customizable_entity_configure_music_response(ground2,{scale_z_start = 1fx,scale_z_end = 1fx/2fx+1fx,startColor = 0x00ff0023,endColor = 0x00ff00a0})
pewpew.customizable_entity_configure_music_response(ground3,{scale_z_start = 1fx,scale_z_end = 1fx/4fx+1fx,startColor = 0x00ff0023,endColor = 0x00ff00a0})

local time = 0

local x,y = random_position()
pewpew.new_bomb(x,y,pewpew.BombType.SMALL_ATOMIZE)

pewpew.add_update_callback(function()
  time = time+1
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if pewpew.entity_get_is_alive(ship) then
    level_particles(-275fx,1275fx,-275fx,1275fx,50fx,fmath.random_fixedpoint(-2fx,2fx),fmath.random_fixedpoint(-2fx,2fx),fmath.random_fixedpoint(-2fx,2fx),0x00ff00ff,0x00ff00cc,57,1)
    if time %11 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1192)
    end
    if time %28 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),7fx,1192)
    end
    if time %44 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),7fx,1192)
    end
    if time %256 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid(x,y)
    end
    if time %1000 == 0 then
      local x,y = 500fx+fmath.random_fixedpoint(-45fx,45fx),500fx+fmath.random_fixedpoint(-45fx,45fx)
      boseld_new(x,y)
      for count = 1,10 do
        pewpew.new_brownian(x,y)
      end
    end
    if time %700 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.FOUR_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.SIX_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      local x,y = random_position()
      bosore_new(x,y)
      for count = 1,12 do
        pewpew.new_asteroid_with_size(x+fmath.random_fixedpoint(-5fx,5fx),y+fmath.random_fixedpoint(-5fx,5fx),0)
      end
    end
    if time %2650 == 0 then
      local x,y = random_position()
      shield_spawn(x,y,25,0xffff00ee,1,215)
      add_ufo(x,y,3fx,true)
    end
    if time %3125 == 0 then
      local x,y = random_position()
      pewpew.new_bonus(x,y,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.TRIPLE,frequency = pewpew.CannonFrequency.FREQ_15,weapon_duration = 105})
    end
  end
end)