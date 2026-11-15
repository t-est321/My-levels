local level_width = 800fx
local level_height = 800fx
local tick = 0
local player_index = 0
local wave = 1
local wave_timer = 0
local wave_duration = 450
local spawn_timer = 0
local initialized = false

local function get_random_edge_pos()
  local side = fmath.random_int(0,3)
  if side == 0 then
    return fmath.random_fixedpoint(50fx,level_width-50fx),-50fx
  elseif side == 1 then
    return fmath.random_fixedpoint(50fx,level_width-50fx),level_height+50fx
  elseif side == 2 then
    return -50fx,fmath.random_fixedpoint(50fx,level_height-50fx)
  else
    return level_width+50fx,fmath.random_fixedpoint(50fx,level_height-50fx)
  end
end

local function get_angle_to_center(x,y)
  local cx = level_width/2fx
  local cy = level_height/2fx
  return fmath.atan2(cy-y,cx-x)
end

local function spawn_wave_enemies()
  local current_wave = wave % 10
  if current_wave == 0 then
    current_wave = 10
  end

  if current_wave == 1 then
    if spawn_timer % 50 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_crowder(x,y)
    end
  elseif current_wave == 2 then
    if spawn_timer % 35 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf(x,y,get_angle_to_center(x,y),5fx,300)
    end
    if spawn_timer % 100 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_rolling_sphere(x,y,get_angle_to_center(x,y),7fx)
    end
  elseif current_wave == 3 then
    if spawn_timer % 30 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_crowder(x,y)
    end
    if spawn_timer % 70 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_red(x,y,get_angle_to_center(x,y),6fx,350)
    end
    if spawn_timer % 150 == 0 then
      pewpew.new_asteroid(
        fmath.random_fixedpoint(100fx,level_width-100fx),
        fmath.random_fixedpoint(100fx,level_height-100fx)
      )
    end
  elseif current_wave == 4 then
    if spawn_timer % 25 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_kamikaze(x,y,get_angle_to_center(x,y))
    end
    if spawn_timer % 60 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_rolling_cube(x,y)
    end
    if spawn_timer % 90 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_blue(x,y,get_angle_to_center(x,y),8fx,400)
    end
  elseif current_wave == 5 then
    if spawn_timer % 20 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_crowder(x,y)
    end
    if spawn_timer % 45 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_inertiac(x,y,2fx,get_angle_to_center(x,y))
    end
    if spawn_timer % 80 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_red(x,y,get_angle_to_center(x,y),7fx,350)
    end
    if spawn_timer % 200 == 0 then
      pewpew.new_mothership(
        fmath.random_fixedpoint(150fx,level_width-150fx),
        fmath.random_fixedpoint(150fx,level_height-150fx),
        pewpew.MothershipType.FOUR_CORNERS,
        fmath.random_fixedpoint(0fx,fmath.tau())
      )
    end
  elseif current_wave == 6 then
    if spawn_timer % 18 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_kamikaze(x,y,get_angle_to_center(x,y))
    end
    if spawn_timer % 30 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_rolling_sphere(x,y,get_angle_to_center(x,y),9fx)
    end
    if spawn_timer % 60 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_red(x,y,get_angle_to_center(x,y),8fx,400)
    end
  elseif current_wave == 7 then
    if spawn_timer % 25 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_crowder(x,y)
    end
    if spawn_timer % 50 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_blue(x,y,get_angle_to_center(x,y),7fx,350)
    end
    if spawn_timer % 100 == 0 then
      pewpew.new_asteroid(
        fmath.random_fixedpoint(100fx,level_width-100fx),
        fmath.random_fixedpoint(100fx,level_height-100fx)
      )
    end
    if spawn_timer % 180 == 0 then
      pewpew.new_mothership(
        fmath.random_fixedpoint(150fx,level_width-150fx),
        fmath.random_fixedpoint(150fx,level_height-150fx),
        pewpew.MothershipType.FIVE_CORNERS,
        fmath.random_fixedpoint(0fx,fmath.tau())
      )
    end
  elseif current_wave == 8 then
    if spawn_timer % 20 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_kamikaze(x,y,get_angle_to_center(x,y))
    end
    if spawn_timer % 35 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_inertiac(x,y,3fx,get_angle_to_center(x,y))
    end
    if spawn_timer % 70 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_red(x,y,get_angle_to_center(x,y),9fx,450)
    end
  elseif current_wave == 9 then
    if spawn_timer % 15 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_crowder(x,y)
    end
    if spawn_timer % 40 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_rolling_sphere(x,y,get_angle_to_center(x,y),10fx)
    end
    if spawn_timer % 60 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_blue(x,y,get_angle_to_center(x,y),8fx,400)
    end
    if spawn_timer % 150 == 0 then
      pewpew.new_mothership(
        fmath.random_fixedpoint(150fx,level_width-150fx),
        fmath.random_fixedpoint(150fx,level_height-150fx),
        pewpew.MothershipType.SIX_CORNERS,
        fmath.random_fixedpoint(0fx,fmath.tau())
      )
    end
  elseif current_wave == 10 then
    if spawn_timer % 12 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_kamikaze(x,y,get_angle_to_center(x,y))
    end
    if spawn_timer % 25 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_rolling_sphere(x,y,get_angle_to_center(x,y),11fx)
    end
    if spawn_timer % 50 == 0 then
      local x,y = get_random_edge_pos()
      pewpew.new_baf_red(x,y,get_angle_to_center(x,y),10fx,500)
    end
    if spawn_timer % 80 == 0 then
      pewpew.new_asteroid(
        fmath.random_fixedpoint(100fx,level_width-100fx),
        fmath.random_fixedpoint(100fx,level_height-100fx)
      )
    end
    if spawn_timer % 200 == 0 then
      pewpew.new_mothership(
        fmath.random_fixedpoint(150fx,level_width-150fx),
        fmath.random_fixedpoint(150fx,level_height-150fx),
        pewpew.MothershipType.SEVEN_CORNERS,
        fmath.random_fixedpoint(0fx,fmath.tau())
      )
    end
  end
end

local function spawn_bonus()
  local bonus_type = fmath.random_int(0,3)
  local x = fmath.random_fixedpoint(100fx,level_width-100fx)
  local y = fmath.random_fixedpoint(100fx,level_height-100fx)
  
  if bonus_type == 0 then
    pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 2})
  elseif bonus_type == 1 then
    pewpew.new_bonus(x,y,pewpew.BonusType.WEAPON,{
      cannon = pewpew.CannonType.TRIPLE,
      frequency = pewpew.CannonFrequency.FREQ_7_5,
      weapon_duration = 300
    })
  elseif bonus_type == 2 then
    pewpew.new_bonus(x,y,pewpew.BonusType.SPEED,{
      speed_factor = 2fx,
      speed_offset = 0fx,
      speed_duration = 250
    })
  else
    pewpew.new_bonus(x,y,pewpew.BonusType.WEAPON,{
      cannon = pewpew.CannonType.HEMISPHERE,
      frequency = pewpew.CannonFrequency.FREQ_10,
      weapon_duration = 200
    })
  end
end

local background_stars = {}

for i = 1, 30 do
  local x = fmath.random_fixedpoint(0fx, level_width)
  local y = fmath.random_fixedpoint(0fx, level_height)
  local star = pewpew.new_customizable_entity(x, y)
  
  pewpew.customizable_entity_set_mesh(star, "/dynamic/graphics.lua", 0)
  pewpew.customizable_entity_set_mesh_color(star, 0x6080ff80)
  pewpew.customizable_entity_set_mesh_scale(star, fmath.random_fixedpoint(1fx, 3fx))
  
  pewpew.customizable_entity_set_visibility_radius(star, 100fx)
  
  table.insert(background_stars, star)
end


pewpew.add_update_callback(function()
  if not initialized then
    initialized = true
    pewpew.set_level_size(level_width,level_height)
    
    local ship_id = pewpew.new_player_ship(level_width/2fx,level_height/2fx,player_index)
    pewpew.configure_player(player_index,{shield = 3,camera_distance = -512fx})
    
    pewpew.new_floating_message(
      level_width/2fx,
      level_height/2fx,
      "survive the waves",
      {scale = 2fx,ticks_before_fade = 120}
    )
  end

  tick = tick+1
  spawn_timer = spawn_timer+1
  wave_timer = wave_timer+1

  local t = fmath.to_fixedpoint(tick)
  for i,star in ipairs(background_stars) do
    if pewpew.entity_get_is_alive(star) then
      local spin = t/100fx+fmath.to_fixedpoint(i)
      pewpew.customizable_entity_set_mesh_angle(star,spin,0fx,0fx,1fx)
    end
  end

  local total_enemies = pewpew.get_entity_count(pewpew.EntityType.CROWDER)+
                        pewpew.get_entity_count(pewpew.EntityType.BAF)+
                        pewpew.get_entity_count(pewpew.EntityType.BAF_RED)+
                        pewpew.get_entity_count(pewpew.EntityType.BAF_BLUE)+
                        pewpew.get_entity_count(pewpew.EntityType.ROLLING_SPHERE)+
                        pewpew.get_entity_count(pewpew.EntityType.ROLLING_CUBE)+
                        pewpew.get_entity_count(pewpew.EntityType.KAMIKAZE)+
                        pewpew.get_entity_count(pewpew.EntityType.INERTIAC)+
                        pewpew.get_entity_count(pewpew.EntityType.MOTHERSHIP)+
                        pewpew.get_entity_count(pewpew.EntityType.ASTEROID)

  if wave_timer >= wave_duration then
    wave_timer = 0
    spawn_timer = 0
    wave = wave+1
    
    local display_wave = wave % 10
    if display_wave == 0 then
      display_wave = 10
    end
    
    spawn_bonus()
    
    pewpew.new_floating_message(
      level_width/2fx,
      level_height/2fx,
      "wave "..tostring(display_wave),
      {scale = 3fx,ticks_before_fade = 100}
    )
    
    pewpew.increase_score_streak_of_player(player_index,1)
  end

  spawn_wave_enemies()

  if tick % 800 == 0 then
    pewpew.new_pointonium(
      fmath.random_fixedpoint(100fx,level_width-100fx),
      fmath.random_fixedpoint(100fx,level_height-100fx),
      256
    )
  end

  local display_wave = wave % 10
  if display_wave == 0 then
    display_wave = 10
  end

  local score = pewpew.get_score_of_player(player_index)
  pewpew.configure_player_hud(player_index,{
    top_left_line = "wave "..tostring(display_wave).." | score "..tostring(score).." | enemies "..tostring(total_enemies)
  })

  local config = pewpew.get_player_configuration(player_index)
  if config.has_lost then
    pewpew.stop_game()
  end
end)