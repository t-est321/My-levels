pewpew.set_level_size(600fx,600fx)
local background = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/asterfury_graphics.lua",0)
local arena = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(arena,"/dynamic/asterfury_graphics.lua",1)
local player_index = 0
local ship = pewpew.new_player_ship(300fx,300fx,player_index)
pewpew.configure_player(player_index,{shield = 3})
pewpew.configure_player_hud(player_index,{top_left_line = "ASTERFURY  WAVE 1"})
pewpew.configure_player_ship_weapon(ship,{cannon = pewpew.CannonType.TIC_TOC,frequency = pewpew.CannonFrequency.FREQ_10})
local asteroid_points = {{70fx,70fx},{530fx,70fx},{70fx,530fx},{530fx,530fx},{300fx,70fx},{530fx,300fx},{70fx,300fx},{300fx,530fx}}
local mothership_y = {530fx,480fx,430fx,380fx,330fx,280fx,230fx,180fx,130fx,80fx,40fx}
local mothership_types = {pewpew.MothershipType.THREE_CORNERS,pewpew.MothershipType.FOUR_CORNERS,pewpew.MothershipType.FIVE_CORNERS,pewpew.MothershipType.SIX_CORNERS,pewpew.MothershipType.SEVEN_CORNERS}
local wave = 0
local state = 0
local phase_time = 0
local intermission_time = 0
local victory_time = 0
function update_hud()
  local text = "ASTERFURY  WAVE "..tostring(wave)
  if state == 2 then
    text = "ASTERFURY  WAVE "..tostring(wave+1).." INCOMING"
  end
  if state == 3 then
    text = "ASTERFURY  VICTORY"
  end
  pewpew.configure_player_hud(player_index,{top_left_line = text})
end
function spawn_asteroids(count,size)
  for i = 1,count do
    local point = asteroid_points[(i-1)%#asteroid_points+1]
    local x = point[1]+fmath.random_fixedpoint(0fx,35fx)
    local y = point[2]+fmath.random_fixedpoint(0fx,35fx)
    pewpew.new_asteroid_with_size(x,y,size)
  end
end
function spawn_fury_wave(count)
  for i = 1,count do
    local x = fmath.random_fixedpoint(140fx,460fx)
    local y = mothership_y[i]
    local angle = fmath.random_fixedpoint(0fx,fmath.tau())
    pewpew.new_mothership(x,y,mothership_types[(i-1)%#mothership_types+1],angle)
  end
end
function clear_enemies()
  local entities = pewpew.get_all_entities()
  for _,entity_id in ipairs(entities) do
    local entity_type = pewpew.get_entity_type(entity_id)
    if entity_type == pewpew.EntityType.ASTEROID or entity_type == pewpew.EntityType.MOTHERSHIP or entity_type == pewpew.EntityType.MOTHERSHIP_BULLET or entity_type == pewpew.EntityType.BAF or entity_type == pewpew.EntityType.BAF_BLUE or entity_type == pewpew.EntityType.BAF_RED then
      pewpew.entity_destroy(entity_id)
    end
  end
end
function spawn_wave()
  wave = wave+1
  phase_time = 0
  state = 1
  if wave == 1 then
    spawn_asteroids(4,pewpew.AsteroidSize.VERY_LARGE)
  elseif wave == 2 then
    spawn_asteroids(7,pewpew.AsteroidSize.LARGE)
  elseif wave == 3 then
    spawn_asteroids(5,pewpew.AsteroidSize.MEDIUM)
    spawn_fury_wave(5)
    pewpew.configure_player_ship_weapon(ship,{cannon = pewpew.CannonType.DOUBLE,frequency = pewpew.CannonFrequency.FREQ_10,duration = 960})
  elseif wave == 4 then
    spawn_asteroids(8,pewpew.AsteroidSize.SMALL)
    spawn_fury_wave(10)
    pewpew.configure_player_ship_weapon(ship,{cannon = pewpew.CannonType.TRIPLE,frequency = pewpew.CannonFrequency.FREQ_10,duration = 960})
  elseif wave == 5 then
    spawn_asteroids(10,pewpew.AsteroidSize.MEDIUM)
    spawn_fury_wave(11)
    pewpew.configure_player_ship_weapon(ship,{cannon = pewpew.CannonType.FOUR_DIRECTIONS,frequency = pewpew.CannonFrequency.FREQ_10,duration = 960})
  end
  update_hud()
end
function is_wave_empty()
  return pewpew.get_entity_count(pewpew.EntityType.ASTEROID) == 0 and pewpew.get_entity_count(pewpew.EntityType.MOTHERSHIP) == 0
end
function finish_wave()
  clear_enemies()
  if wave == 5 then
    state = 3
    victory_time = 0
    update_hud()
    pewpew.new_floating_message(300fx,300fx,"ASTERFURY CLEAR",{scale = 2fx,ticks_before_fade = 120,is_optional = false})
  else
    state = 2
    intermission_time = 0
    update_hud()
  end
end
function level_tick()
  local config = pewpew.get_player_configuration(player_index)
  if config["has_lost"] == true then
    pewpew.stop_game()
    return
  end
  if state == 1 then
    phase_time = phase_time+1
    if phase_time > 45 and is_wave_empty() then
      finish_wave()
    elseif wave <= 2 and phase_time >= 900 then
      finish_wave()
    elseif wave >= 3 and phase_time >= 960 then
      finish_wave()
    end
  elseif state == 2 then
    intermission_time = intermission_time+1
    if intermission_time == 60 then
      spawn_wave()
    end
  elseif state == 3 then
    victory_time = victory_time+1
    if victory_time == 150 then
      pewpew.stop_game()
    end
  end
end
spawn_wave()
pewpew.add_update_callback(level_tick)
