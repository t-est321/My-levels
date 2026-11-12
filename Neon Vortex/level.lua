local width = 800fx
local height = 800fx
local center_x = width/2fx
local center_y = height/2fx
local tau = fmath.tau()

pewpew.set_level_size(width,height)

local background = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/background.lua",0)

local border = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(border,"/dynamic/background.lua",1)

local outer_ring = pewpew.new_customizable_entity(center_x,center_y)
pewpew.customizable_entity_set_mesh(outer_ring,"/dynamic/vortex.lua",0)
pewpew.customizable_entity_set_angle_interpolation(outer_ring,true)
pewpew.entity_set_update_callback(outer_ring,function(entity_id)
  pewpew.customizable_entity_add_rotation_to_mesh(entity_id,tau/120fx,0fx,0fx,1fx)
end)

local inner_ring = pewpew.new_customizable_entity(center_x,center_y)
pewpew.customizable_entity_set_mesh(inner_ring,"/dynamic/vortex.lua",1)
pewpew.customizable_entity_set_angle_interpolation(inner_ring,true)
pewpew.entity_set_update_callback(inner_ring,function(entity_id)
  pewpew.customizable_entity_add_rotation_to_mesh(entity_id,-tau/90fx,0fx,0fx,1fx)
end)

pewpew.configure_player(0,{shield = 3,camera_distance = -30fx})
local ship_id = pewpew.new_player_ship(center_x,center_y-200fx,0)
pewpew.configure_player_ship_weapon(ship_id,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.DOUBLE})

local time = 0
local wave = 0
local wave_interval = 240
local pulse_interval = 300
local next_wave = 60
local next_pulse = pulse_interval

local function spawn_wave()
  wave = wave+1
  local count = 3+wave*2
  if count > 20 then
    count = 20
  end
  for i = 1,count do
    local side = fmath.random_int(0,3)
    local x = 0fx
    local y = 0fx
    if side == 0 then
      x = fmath.random_fixedpoint(0fx,width)
    elseif side == 1 then
      x = width
      y = fmath.random_fixedpoint(0fx,height)
    elseif side == 2 then
      x = fmath.random_fixedpoint(0fx,width)
      y = height
    else
      y = fmath.random_fixedpoint(0fx,height)
    end
    local angle = fmath.atan2(center_y-y,center_x-x)
    local speed = 4fx+fmath.from_fraction(wave,2)
    if speed > 12fx then
      speed = 12fx
    end
    local roll = fmath.random_int(0,99)
    if roll < 60 then
      pewpew.new_baf(x,y,angle,speed,-1)
    elseif roll < 85 then
      pewpew.new_inertiac(x,y,1fx/4fx,angle)
    else
      pewpew.new_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,angle)
    end
    pewpew.create_explosion(x,y,0x00ffffff,1fx/2fx,20)
  end
  pewpew.play_sound("/dynamic/sounds.lua",1,center_x,center_y)
  pewpew.increase_score_of_player(0,wave*50)
end

local function fire_pulse()
  local entities = pewpew.get_entities_colliding_with_disk(center_x,center_y,180fx)
  for i = 1,#entities do
    pewpew.entity_react_to_weapon(entities[i],{type = pewpew.WeaponType.ATOMIZE_EXPLOSION,x = center_x,y = center_y,player_index = 0})
  end
  pewpew.create_explosion(center_x,center_y,0xff00ffff,2fx,80)
  pewpew.play_sound("/dynamic/sounds.lua",0,center_x,center_y)
end

function level_tick()
  time = time+1
  pewpew.increase_score_of_player(0,1)
  if time >= next_wave then
    spawn_wave()
    next_wave = time+wave_interval
  end
  if time >= next_pulse then
    fire_pulse()
    next_pulse = time+pulse_interval
  end
  if time%15 == 0 then
    local seconds = fmath.to_int(fmath.from_fraction(next_pulse-time+29,30))
    pewpew.configure_player_hud(0,{top_left_line = "Wave "..wave.."  Pulse in "..seconds.."s"})
  end
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] == true then
    pewpew.stop_game()
  end
end

pewpew.add_update_callback(level_tick)
