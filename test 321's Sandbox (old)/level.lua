local random_weapon = fmath.random_int(1,20)

local width = 1000fx
local height = 1000fx
pewpew.set_level_size(width,height)

local background = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/rectangles_graphic.lua",0)
local bg = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bg,"/dynamic/level_graphics.lua",0)
local rdots = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(rdots,"/dynamic/random_dots.lua",0)

local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end

local ship = pewpew.new_player_ship(500fx,500fx,0)
pewpew.configure_player(0,{shield = 3,camera_distance = -350fx,camera_rotation_x_axis = fmath.tau()/-42fx})

local ram = pewpew.new_customizable_entity(500fx,1125fx,100fx)
pewpew.customizable_entity_set_mesh_scale(ram,1fx)

if random_weapon == 1 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_30,cannon = pewpew.CannonType.SINGLE})
elseif random_weapon == 2 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_5,cannon = pewpew.CannonType.DOUBLE})
elseif random_weapon == 3 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_1,cannon = pewpew.CannonType.HEMISPHERE})
elseif random_weapon == 4 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.TRIPLE})
elseif random_weapon == 5 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.LASER})
elseif random_weapon == 6 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_30,cannon = pewpew.CannonType.SHOTGUN})
elseif random_weapon == 7 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_1,cannon = pewpew.CannonType.SHOTGUN})
elseif random_weapon == 8 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.TIC_TOC})
elseif random_weapon == 9 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.FOUR_DIRECTIONS})
elseif random_weapon == 10 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_30,cannon = pewpew.CannonType.TRIPLE})
elseif random_weapon == 11 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.DOUBLE_SWIPE})
elseif random_weapon == 12 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_30,cannon = pewpew.CannonType.DOUBLE_SWIPE})
elseif random_weapon == 13 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_5,cannon = pewpew.CannonType.LASER})
elseif random_weapon == 14 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_30,cannon = pewpew.CannonType.LASER})
elseif random_weapon == 15 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_30,cannon = pewpew.CannonType.FOUR_DIRECTIONS})
elseif random_weapon == 16 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.SHOTGUN})
elseif random_weapon == 17 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_5,cannon = pewpew.CannonType.SINGLE})
elseif random_weapon == 18 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_5,cannon = pewpew.CannonType.TRIPLE})
elseif random_weapon == 19 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_3,cannon = pewpew.CannonType.HEMISPHERE})
elseif random_weapon == 20 then
  pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.FOUR_DIRECTIONS})
end

local time = 0
local level_time = 0
local current_level = fmath.random_int(1,42)
local level_duration = 90*30

pewpew.create_explosion(375fx,375fx,0xffffffff,3fx,100)

local level_configs = {
  [1] = {hud = "#ffff00ffB#0099ffffaf#ff0000ffs#ffffffff fast"},
  [2] = {hud = "#ff7000ffMothership"},
  [3] = {hud = "#ffcb00ffInertiacs"},
  [4] = {hud = "#ff0000ffBaf#ffffffff red"},
  [5] = {hud = "#ff0000aaMotherships 2"},
  [6] = {hud = "#ff0000ffUFO #ffffffffattack"},
  [7] = {hud = "Asteroids small"},
  [8] = {hud = "#ffcb00ffInertiacs #ff0000ff2"},
  [9] = {hud = "#ffff00ffWave#ff0000ff attack"},
  [10] = {hud = "#23ff12ffRolling #77df24ffcubes"},
  [11] = {hud = "Rolling #ff0000ffspheres"},
  [12] = {hud = "#ff0000eeAttack"},
  [13] = {hud = "Astero#ff0000ffbaf"},
  [14] = {hud = "#00ffffffRolling #ffffffffStorm"},
  [15] = {hud = "#ff0000ffWary #ffffffffBarrage"},
  [16] = {hud = "Weapon #ffff00ffZone"},
  [17] = {hud = "UFO #00ff00ffHunt"},
  [18] = {hud = "#ffff00ffMothership #ff0000ffMega #ffffffffBullets"},
  [19] = {hud = "Wary #ff0000ffSnipers"},
  [20] = {hud = "#00ffffffUFO #ffffffff& #ff0000ffWary"},
  [21] = {hud = "#ff00ffffAssault #ffffffffMixed"},
  [22] = {hud = "#00ff00ffInertia #ffffffffControl (TEMPORARY!)"},
  [23] = {hud = "#ffff00ffMothership #ff0000ffMayhem"},
  [24] = {hud = "Wary #ff00ffffDanger"},
  [25] = {hud = "#00ffffffBrownian #ffffffffRain"},
  [26] = {hud = "#ffff00ffRolling #ffffffffStorm"},
  [27] = {hud = "Rolling #00ffffffChaos"},
  [28] = {hud = "Baf #ff00ffffRain"},
  [29] = {hud = "#ff0000ffSuper #ffffffffMothership"},
  [30] = {hud = "#ff00ffffKamikaze #ffffffffRush"},
  [31] = {hud = "#ffff00ffSpiny #ffffffffField"},
  [32] = {hud = "#ff0000ffBomb #ffffffffStorm (TEMPORARY!)"},
  [33] = {hud = "#00ff00ffCrowder #ffffffffHorde"},
  [34] = {hud = "#00ffffffAsteroid #ffffffffMega"},
  [35] = {hud = "#ff0000ffULTIMATE #ffffffffBOSS (TEMPORARY!)"},
  [36] = {hud = "#ff6600ffInertiac #ffffffffBlast"},
  [37] = {hud = "#9900ffffBrownian #ffffffffChaos"},
  [38] = {hud = "#ff0099ffWary #ffffffffSphere #ff0000ffMix"},
  [39] = {hud = "#ffff00ffUFO #ffffffffSwarm"},
  [40] = {hud = "#00ff99ffKamikaze #ffffffffWave"},
  [41] = {hud = "#ff0000ffSuper #ffff00ffMothership #ffffffffFrenzy"},
  [42] = {hud = "#ff0000ffCHAOS #ffffffffMODE"}
}

local function clear_enemies()
  local entities = pewpew.get_all_entities()
  for _,id in ipairs(entities) do
    if id ~= ship and id ~= background and id ~= bg and id ~= rdots and id ~= ram then
      pewpew.entity_destroy(id)
    end
  end
end

local function add_ufo(x,y,speed,collision)
  if collision == false then
    pewpew.new_ufo(x,y,7fx)
  end
  if collision == true then
    local ufo = pewpew.new_ufo(x,y,7fx)
    pewpew.ufo_set_enable_collisions_with_walls(ufo,true)
  end
end

local function start_level(lvl)
  current_level = lvl
  level_time = 0
  clear_enemies()
  local cfg = level_configs[lvl]
  if cfg then
    pewpew.configure_player_hud(0,{top_left_line = cfg.hud})
  end
  local px,py = pewpew.entity_get_position(ship)
  pewpew.create_explosion(px,py,0xffffffff,2fx,50)
end

start_level(current_level)

local function get_next_level()
  local next_lvl
  repeat
    next_lvl = fmath.random_int(1,42)
  until next_lvl ~= current_level
  return next_lvl
end
pewpew.add_update_callback(function()
  time = time+1
  level_time = level_time+1
  if time%2 == 0 then
    local memory_str = tostring(collectgarbage("count")//1).." KB"
    pewpew.customizable_entity_set_string(ram,memory_str)
  end
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if level_time >= level_duration then
    start_level(get_next_level())
  end
  if time%1850 == 0 then
    local x,y = random_position()
    pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
  end
  if current_level == 1 then
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,-1)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,-1)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,-1)
    end
  elseif current_level == 2 then
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%30 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
  elseif current_level == 3 then
    if level_time%200 == 0 then
      for count = 1,20 do
        local x,y = random_position()
        pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
    end
    if level_time%50 == 0 then
      local x,y = random_position()
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
  elseif current_level == 4 then
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,-1)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),20fx,-1)
    end
  elseif current_level == 5 then
    if level_time%100 == 0 then
      local angle = fmath.random_fixedpoint(0fx,fmath.tau())
      pewpew.new_super_mothership(5fx,5fx,pewpew.MothershipType.THREE_CORNERS,angle)
      pewpew.new_super_mothership(5fx,5fx,pewpew.MothershipType.SIX_CORNERS,angle)
      pewpew.new_super_mothership(5fx,5fx,pewpew.MothershipType.FIVE_CORNERS,angle)
      pewpew.new_super_mothership(5fx,5fx,pewpew.MothershipType.SEVEN_CORNERS,angle)
      pewpew.new_super_mothership(5fx,5fx,pewpew.MothershipType.FOUR_CORNERS,angle)
    end
    if level_time%50 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,0xff0000ff,true)
    end
  elseif current_level == 6 then
    if level_time%40 == 0 then
      local x,y = random_position()
      add_ufo(x,y,7fx,true)
      for count = 1,20 do
        pewpew.new_brownian(x,y)
      end
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,-1)
    end
  elseif current_level == 7 then
    if level_time%2 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid_with_size(x,y,0)
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid_with_size(x,y,1)
    end
  elseif current_level == 8 then
    if level_time%15 == 0 then
      pewpew.increase_score_of_player(0,1)
    end
    if level_time%30 == 0 then
      local x,y = random_position()
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if pewpew.get_entity_count(pewpew.EntityType.INERTIAC) == 0 then
      start_level(get_next_level())
    end
  elseif current_level == 9 then
    pewpew.increase_score_of_player(0,1)
    if level_time%2 == 0 then
      pewpew.new_baf(500fx,500fx,fmath.random_fixedpoint(0fx,fmath.tau()),35fx,10)
    end
    if level_time%25 == 0 then
      pewpew.new_baf_red(500fx,500fx,fmath.random_fixedpoint(0fx,fmath.tau()),35fx,10)
    end
    if level_time%50 == 0 then
      pewpew.new_baf_blue(500fx,500fx,fmath.random_fixedpoint(0fx,fmath.tau()),35fx,10)
    end
  elseif current_level == 10 then
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_cube(x,y)
      pewpew.increase_score_of_player(0,1)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_cube(x,y)
      pewpew.new_rolling_cube(x,y)
    end
  elseif current_level == 11 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
      pewpew.new_brownian(x,y)
      pewpew.increase_score_of_player(0,1)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
  elseif current_level == 12 then
    if level_time%14 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),7fx,1300)
    end
    if level_time%40 == 0 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%25 == 0 then
      local x,y = random_position()
      add_ufo(x,y,5fx,true)
    end
  elseif current_level == 13 then
    if level_time%22 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid_with_size(x,y,2)
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1300)
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1300)
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1300)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1000)
    end
  elseif current_level == 14 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
    if level_time%12 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),3fx)
      pewpew.new_rolling_cube(x,y)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,-1)
    end
  elseif current_level == 15 then
    if level_time%12 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
      pewpew.new_wary(x,y)
    end
    if level_time%30 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,0xffffffff,false)
    end
  elseif current_level == 16 then
    if level_time%200 == 0 then
      local x,y = random_position()
      pewpew.new_weapon_zone(x,y,pewpew.CannonType.SINGLE,pewpew.CannonFrequency.FREQ_2,{radius = 60fx,number_of_sides = 8})
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
    end
    if level_time%25 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),4fx,-1)
    end
  elseif current_level == 17 then
    if level_time%12 == 0 then
      local x,y = random_position()
      add_ufo(x,y,5fx,true)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      add_ufo(x,y,5fx,true)
      pewpew.new_brownian(x,y)
    end
  elseif current_level == 18 then
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),10fx,0xff0000ff,true)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,0xffff00ff,true)
    end
    if level_time%40 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.FOUR_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
  elseif current_level == 19 then
    if level_time%12 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,0xffffffff,false)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),12fx,0xff0000ff,true)
    end
  elseif current_level == 20 then
    if level_time%15 == 0 then
      local x,y = random_position()
      add_ufo(x,y,5fx,true)
      pewpew.new_wary(x,y)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      add_ufo(x,y,5fx,true)
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,-1)
    end
  elseif current_level == 21 then
    if level_time%25 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.FOUR_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      add_ufo(x,y,5fx,true)
      pewpew.new_wary(x,y)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,-1)
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
  elseif current_level == 22 then
    if level_time%5 == 0 then
      local x,y = random_position()
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_brownian(x,y)
    end
  elseif current_level == 23 then
    if level_time%40 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership(x,y,pewpew.MothershipType.SIX_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),10fx,0xffff00ff,false)
    end
  elseif current_level == 24 then
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
      pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
    end
  elseif current_level == 25 then
    if level_time%5 == 0 then
      local x,y = random_position()
      pewpew.new_brownian(x,y)
      pewpew.increase_score_of_player(0,5)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_brownian(x,y)
      pewpew.new_brownian(x,y)
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
    end
  elseif current_level == 26 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_cube(x,y)
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,-1)
    end
  elseif current_level == 27 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
      pewpew.new_rolling_cube(x,y)
    end
    if level_time%12 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),3fx)
      pewpew.new_rolling_cube(x,y)
      pewpew.new_rolling_cube(x,y)
    end
  elseif current_level == 28 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),4fx,1000)
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),4fx,1000)
    end
    if level_time%12 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1000)
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,1000)
    end
  elseif current_level == 29 then
    if level_time%30 == 0 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.FOUR_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,0xff0000ff,false)
    end
  elseif current_level == 30 then
    if level_time%5 == 0 then
      local x,y = random_position()
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,-1)
    end
  elseif current_level == 31 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
      pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
    end
  elseif current_level == 32 then
    if level_time%40 == 0 then
      local x,y = random_position()
      pewpew.new_bomb(x,y,pewpew.BombType.ATOMIZE)
    end
    if level_time%55 == 0 then
      local x,y = random_position()
      pewpew.new_bomb(x,y,pewpew.BombType.REPULSIVE)
    end
    if level_time%70 == 0 then
      local x,y = random_position()
      pewpew.new_bomb(x,y,pewpew.BombType.FREEZE)
    end
    if level_time%12 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,-1)
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,-1)
    end
  elseif current_level == 33 then
    if level_time%3 == 0 then
      local x,y = random_position()
      pewpew.new_crowder(x,y)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_crowder(x,y)
      pewpew.new_crowder(x,y)
      pewpew.new_crowder(x,y)
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),4fx,-1)
    end
  elseif current_level == 34 then
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid_with_size(x,y,2)
      pewpew.new_asteroid_with_size(x,y,2)
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_asteroid_with_size(x,y,1)
      pewpew.new_asteroid_with_size(x,y,2)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,-1)
    end
  elseif current_level == 35 then
    if level_time%50 == 0 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1500)
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),10fx,0xff0000ff,true)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
  elseif current_level == 36 then
    if level_time%3 == 0 then
      local x,y = random_position()
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_bomb(x,y,pewpew.BombType.FREEZE)
      pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
  elseif current_level == 37 then
    if level_time%3 == 0 then
      local x,y = random_position()
      pewpew.new_brownian(x,y)
      pewpew.new_brownian(x,y)
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),3fx)
      pewpew.new_brownian(x,y)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,-1)
    end
  elseif current_level == 38 then
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx)
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,0xff0099ff,false)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),3fx)
      pewpew.new_wary(x,y)
    end
  elseif current_level == 39 then
    if level_time%8 == 0 then
      local x,y = random_position()
      add_ufo(x,y,5fx,true)
      add_ufo(x,y,7fx,true)
    end
    if level_time%12 == 0 then
      local x,y = random_position()
      add_ufo(x,y,6fx,true)
      pewpew.new_brownian(x,y)
      pewpew.new_brownian(x,y)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),5fx,-1)
    end
  elseif current_level == 40 then
    if level_time%4 == 0 then
      local x,y = random_position()
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,1200)
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
  elseif current_level == 41 then
    if level_time%25 == 0 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.SIX_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),12fx,0xffff00ff,true)
      pewpew.new_mothership_bullet(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),10fx,0xff0000ff,true)
    end
    if level_time%15 == 0 then
      local x,y = random_position()
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,-1)
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
    end
  elseif current_level == 42 then
    if level_time%4 == 0 then
      local x,y = random_position()
      pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))
      pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),10fx,-1)
    end
    if level_time%10 == 0 then
      local x,y = random_position()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
      add_ufo(x,y,7fx,true)
    end
    if level_time%8 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_sphere(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),4fx)
      pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),2fx)
    end
    if level_time%20 == 0 then
      local x,y = random_position()
      pewpew.new_bomb(x,y,pewpew.BombType.ATOMIZE)
      pewpew.new_crowder(x,y)
      pewpew.new_crowder(x,y)
    end
  end
end)