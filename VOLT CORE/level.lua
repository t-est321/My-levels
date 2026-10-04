local level_width = 700fx
local level_height = 500fx
pewpew.set_level_size(level_width,level_height)

local background_id = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background_id,"/dynamic/graphics.lua",0)

pewpew.configure_player(0,{shield = 2,camera_distance = -15fx})
pewpew.configure_player_hud(0,{top_left_line = "VOLT CORE"})

local ship_id = pewpew.new_player_ship(level_width/2fx,level_height-80fx,0)
pewpew.configure_player_ship_weapon(ship_id,{frequency = pewpew.CannonFrequency.FREQ_7_5,cannon = pewpew.CannonType.TRIPLE})

local boss_total_life = 480
local boss_life = boss_total_life
local boss_x = level_width/2fx
local boss_y = 170fx
local boss_id = pewpew.new_customizable_entity(boss_x,boss_y)
pewpew.customizable_entity_set_mesh(boss_id,"/dynamic/graphics.lua",1)
pewpew.customizable_entity_set_mesh_scale(boss_id,2fx)
pewpew.customizable_entity_set_position_interpolation(boss_id,true)
pewpew.entity_set_radius(boss_id,30fx)
pewpew.customizable_entity_start_spawning(boss_id,60)
pewpew.add_arrow_to_player_ship(ship_id,boss_id,0xff00ffff)

local time = 0
local phase = 1
local victory = false
local victory_timer = 0
local dying_timer = 0
local transition_timer = 60
local orbit_angle = 0fx
local spiral_angle = 0fx
local spiral_angle_2 = fmath.tau()/2fx
local last_hud_life = -1
local bullet_speed = 3fx+fmath.from_fraction(1,3)
local fast_bullet_speed = 5fx
local orb_ids = {}
local orb_life = {}
local orb_count = 3
local ring_id = nil
local ring_r = 0fx
local ring_x = 0fx
local ring_y = 0fx
local ring_hit = false

local function is_boss_invulnerable()
  return orb_count > 0 or transition_timer > 0 or dying_timer > 0 or victory == true
end

local function angle_to_player_from(x,y)
  if pewpew.entity_get_is_alive(ship_id) == true then
    local px,py = pewpew.entity_get_position(ship_id)
    return fmath.atan2(py-y,px-x)
  end
  return 0fx
end

local function clear_enemy_bullets()
  local entities = pewpew.get_all_entities()
  local i = 1
  while i <= #entities do
    if pewpew.get_entity_type(entities[i]) == pewpew.EntityType.MOTHERSHIP_BULLET then
      pewpew.entity_destroy(entities[i])
    end
    i = i+1
  end
end

local function fire_spiral_arms(count,base_angle,speed,color)
  local i = 0
  while i < count do
    local angle = base_angle+fmath.tau()/fmath.to_fixedpoint(count)*fmath.to_fixedpoint(i)
    pewpew.new_mothership_bullet(boss_x,boss_y,angle,speed,color,false)
    i = i+1
  end
end

local function fire_fan_at_player(count,spread,speed,color)
  local aim = angle_to_player_from(boss_x,boss_y)
  local half_offset = fmath.to_fixedpoint(count-1)/2fx
  local i = 0
  while i < count do
    local angle = aim+(fmath.to_fixedpoint(i)-half_offset)*spread
    pewpew.new_mothership_bullet(boss_x,boss_y,angle,speed,color,false)
    i = i+1
  end
end

local function spawn_kamikaze_wave(count)
  local i = 0
  while i < count do
    local x = fmath.random_fixedpoint(30fx,level_width-30fx)
    local aim = angle_to_player_from(x,10fx)
    pewpew.new_kamikaze(x,10fx,aim)
    i = i+1
  end
end

local function start_ring()
  ring_id = pewpew.new_customizable_entity(boss_x,boss_y)
  pewpew.customizable_entity_set_mesh(ring_id,"/dynamic/graphics.lua",3)
  pewpew.customizable_entity_set_visibility_radius(ring_id,480fx)
  ring_r = 20fx
  ring_x = boss_x
  ring_y = boss_y
  ring_hit = false
  pewpew.customizable_entity_set_mesh_scale(ring_id,ring_r/10fx)
end

local function on_boss_weapon_hit(entity_id,player_index,weapon_type,weapon_x,weapon_y)
  if is_boss_invulnerable() then
    return true
  end
  boss_life = boss_life-1
  pewpew.increase_score_of_player(player_index,10)
  pewpew.create_explosion(boss_x,boss_y,0x00ffffff,1fx/5fx,4)
  if boss_life <= 0 then
    boss_life = 0
    dying_timer = 60
    clear_enemy_bullets()
    if ring_id ~= nil then
      pewpew.entity_destroy(ring_id)
      ring_id = nil
    end
    local k = 0
    while k < 3 do
      if orb_ids[k] ~= nil then
        pewpew.entity_destroy(orb_ids[k])
        orb_ids[k] = nil
      end
      k = k+1
    end
    orb_count = 0
    pewpew.configure_player_hud(0,{top_left_line = "CORE BREACH"})
    pewpew.new_floating_message(boss_x,boss_y-60fx,"#ff8000ffCORE BREACH",{scale = 2fx,ticks_before_fade = 50,is_optional = false})
  end
  return true
end

local function on_boss_player_collision(entity_id,player_index,ship_entity_id)
  pewpew.add_damage_to_player_ship(ship_entity_id,1)
end

local function make_orb_weapon_callback(index)
  return function(entity_id,player_index,weapon_type,weapon_x,weapon_y)
    if orb_ids[index] == nil then
      return false
    end
    orb_life[index] = orb_life[index]-1
    local x,y = pewpew.entity_get_position(orb_ids[index])
    pewpew.create_explosion(x,y,0xffe000ff,1fx/5fx,4)
    if orb_life[index] <= 0 then
      pewpew.entity_destroy(orb_ids[index])
      orb_ids[index] = nil
      orb_count = orb_count-1
      pewpew.increase_score_of_player(player_index,200)
      pewpew.increase_score_streak_of_player(player_index,200)
      if orb_count == 0 then
        pewpew.increase_score_of_player(player_index,500)
        pewpew.new_floating_message(boss_x,boss_y+60fx,"#00ffffffCORE EXPOSED",{scale = 2fx,ticks_before_fade = 80,is_optional = false})
        pewpew.new_bonus(level_width/2fx,level_height/2fx,pewpew.BonusType.SHIELD,{number_of_shields = 1})
      end
    end
    return true
  end
end

local i = 0
while i < 3 do
  local orb_id = pewpew.new_customizable_entity(boss_x,boss_y)
  pewpew.customizable_entity_set_mesh(orb_id,"/dynamic/graphics.lua",2)
  pewpew.customizable_entity_set_position_interpolation(orb_id,true)
  pewpew.entity_set_radius(orb_id,8fx)
  pewpew.customizable_entity_set_visibility_radius(orb_id,60fx)
  pewpew.customizable_entity_set_weapon_collision_callback(orb_id,make_orb_weapon_callback(i))
  orb_ids[i] = orb_id
  orb_life[i] = 8
  i = i+1
end

pewpew.customizable_entity_set_player_collision_callback(boss_id,on_boss_player_collision)
pewpew.customizable_entity_set_weapon_collision_callback(boss_id,on_boss_weapon_hit)

local function level_tick()
  time = time+1
  local player_conf = pewpew.get_player_configuration(0)
  if player_conf["has_lost"] == true then
    pewpew.stop_game()
    return
  end
  if victory == true then
    victory_timer = victory_timer+1
    if victory_timer == 45 then
      pewpew.entity_destroy(boss_id)
      pewpew.create_explosion(boss_x,boss_y,0xffffffff,3fx,60)
    end
    if victory_timer == 60 then
      pewpew.new_pointonium(boss_x,boss_y,256)
      pewpew.configure_player_hud(0,{top_left_line = "CORE DESTROYED"})
    end
    if victory_timer == 240 then
      pewpew.stop_game()
    end
    return
  end
  if pewpew.entity_get_is_alive(boss_id) == false then
    return
  end
  if dying_timer > 0 then
    dying_timer = dying_timer-1
    local dx = fmath.random_fixedpoint(-30fx,30fx)
    local dy = fmath.random_fixedpoint(-30fx,30fx)
    pewpew.create_explosion(boss_x+dx,boss_y+dy,0xff8000ff,1fx,10)
    if dying_timer == 0 then
      victory = true
      victory_timer = 0
      pewpew.increase_score_of_player(0,3000)
      pewpew.increase_score_streak_of_player(0,3000)
      pewpew.new_floating_message(boss_x,boss_y,"#00ff00ffVICTORY",{scale = 3fx,ticks_before_fade = 200,is_optional = false})
    end
    return
  end

  if time == 30 then
    pewpew.new_floating_message(boss_x,boss_y-70fx,"#00ffffffVOLT CORE",{scale = 3fx,ticks_before_fade = 90,is_optional = false})
  end
  if time == 100 then
    pewpew.new_floating_message(level_width/2fx,level_height-160fx,"DESTROY THE SHIELD ORBS",{scale = 1fx,ticks_before_fade = 90,is_optional = false})
  end

  local a1 = fmath.to_fixedpoint(time%600)*fmath.tau()/600fx
  local a2 = fmath.to_fixedpoint(time%440)*fmath.tau()/440fx+fmath.tau()/4fx
  local sin1,cos1 = fmath.sincos(a1)
  local sin2,cos2 = fmath.sincos(a2)
  local amp_x = 170fx
  local amp_y = 60fx
  if phase == 3 then
    amp_x = 220fx
    amp_y = 90fx
  end
  boss_x = level_width/2fx+amp_x*sin1
  boss_y = 170fx+amp_y*sin2
  pewpew.entity_set_position(boss_id,boss_x,boss_y)

  orbit_angle = orbit_angle+fmath.tau()/240fx
  if orbit_angle >= fmath.tau() then
    orbit_angle = orbit_angle-fmath.tau()
  end
  local k = 0
  while k < 3 do
    local orb_id = orb_ids[k]
    if orb_id ~= nil then
      local oa = orbit_angle+fmath.tau()*fmath.from_fraction(k,3)
      local os,oc = fmath.sincos(oa)
      pewpew.entity_set_position(orb_id,boss_x+40fx*oc,boss_y+40fx*os)
    end
    k = k+1
  end

  if transition_timer > 0 then
    transition_timer = transition_timer-1
  end

  if phase == 1 and boss_life <= 320 then
    phase = 2
    transition_timer = 90
    clear_enemy_bullets()
    pewpew.customizable_entity_set_mesh_color(boss_id,0xffc080ff)
    pewpew.new_floating_message(boss_x,boss_y-50fx,"#ffc080ffPHASE 2",{scale = 2fx,ticks_before_fade = 90,is_optional = false})
    pewpew.create_explosion(boss_x,boss_y,0xffc080ff,2fx,40)
    pewpew.increase_score_of_player(0,500)
    pewpew.new_bonus(boss_x,boss_y+80fx,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.TIC_TOC,frequency = pewpew.CannonFrequency.FREQ_5,weapon_duration = 600})
  end
  if phase == 2 and boss_life <= 160 then
    phase = 3
    transition_timer = 90
    clear_enemy_bullets()
    pewpew.customizable_entity_set_mesh_color(boss_id,0xff5050ff)
    pewpew.new_floating_message(boss_x,boss_y-50fx,"#ff5050ffPHASE 3 MAXIMUM POWER",{scale = 2fx,ticks_before_fade = 90,is_optional = false})
    pewpew.create_explosion(boss_x,boss_y,0xff5050ff,2fx,40)
    pewpew.increase_score_of_player(0,500)
  end

  local pct = boss_life*100 // boss_total_life
  if pct ~= last_hud_life then
    last_hud_life = pct
    pewpew.configure_player_hud(0,{top_left_line = "VOLT CORE HP: "..pct.."%"})
  end

  if transition_timer == 0 then
    if phase == 1 then
      if time%6 == 0 then
        spiral_angle = spiral_angle+fmath.tau()/18fx
        if spiral_angle >= fmath.tau() then
          spiral_angle = spiral_angle-fmath.tau()
        end
        fire_spiral_arms(2,spiral_angle,bullet_speed,0x00ffffff)
      end
      if time%90 == 30 then
        fire_fan_at_player(3,fmath.tau()/48fx,fast_bullet_speed,0xff4040ff)
      end
    elseif phase == 2 then
      if time%5 == 0 then
        spiral_angle = spiral_angle+fmath.tau()/16fx
        if spiral_angle >= fmath.tau() then
          spiral_angle = spiral_angle-fmath.tau()
        end
        spiral_angle_2 = spiral_angle_2-fmath.tau()/16fx
        if spiral_angle_2 < 0fx then
          spiral_angle_2 = spiral_angle_2+fmath.tau()
        end
        fire_spiral_arms(2,spiral_angle,bullet_speed,0x00ffffff)
        fire_spiral_arms(2,spiral_angle_2,bullet_speed,0xb040ffff)
      end
      if time%75 == 40 then
        fire_fan_at_player(5,fmath.tau()/40fx,fast_bullet_speed,0xff4040ff)
      end
      if time%150 == 75 then
        spawn_kamikaze_wave(1)
      end
    else
      if time%4 == 0 then
        spiral_angle = spiral_angle+fmath.tau()/20fx
        if spiral_angle >= fmath.tau() then
          spiral_angle = spiral_angle-fmath.tau()
        end
        spiral_angle_2 = spiral_angle_2-fmath.tau()/20fx
        if spiral_angle_2 < 0fx then
          spiral_angle_2 = spiral_angle_2+fmath.tau()
        end
        fire_spiral_arms(3,spiral_angle,bullet_speed,0xff6060ff)
        fire_spiral_arms(3,spiral_angle_2,bullet_speed+1fx,0xffc040ff)
      end
      if time%120 == 60 then
        fire_spiral_arms(24,fmath.to_fixedpoint(time%240)*fmath.tau()/240fx,4fx,0xff2020ff)
      end
      if time%180 == 90 and ring_id == nil then
        start_ring()
      end
      if time%240 == 120 then
        spawn_kamikaze_wave(2)
      end
    end
  end

  if ring_id ~= nil then
    ring_r = ring_r+4fx
    pewpew.customizable_entity_set_mesh_scale(ring_id,ring_r/10fx)
    if ring_hit == false and pewpew.entity_get_is_alive(ship_id) == true then
      local px,py = pewpew.entity_get_position(ship_id)
      local dx = px-ring_x
      local dy = py-ring_y
      local dist = fmath.sqrt(dx*dx+dy*dy)
      if fmath.abs_fixedpoint(dist-ring_r) < 8fx then
        ring_hit = true
        pewpew.add_damage_to_player_ship(ship_id,1)
        pewpew.create_explosion(px,py,0xff4040ff,1fx,10)
      end
    end
    if ring_r > 460fx then
      pewpew.entity_destroy(ring_id)
      ring_id = nil
    end
  end
end

pewpew.add_update_callback(level_tick)
