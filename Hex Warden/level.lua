local width = 900fx
local height = 900fx
local center_x = width/2fx
local center_y = height/2fx
local tau = fmath.tau()

pewpew.set_level_size(width,height)

local background = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/background.lua",0)

local border = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(border,"/dynamic/background.lua",1)

pewpew.configure_player(0,{shield = 5,camera_distance = -60fx})
local ship_id = pewpew.new_player_ship(center_x,180fx,0)
pewpew.configure_player_ship_weapon(ship_id,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.DOUBLE})

local max_hp = 450
local hp = max_hp
local phase = 1
local time = 0
local dead = false
local death_timer = 0
local transition = 0
local contact_cd = 0
local hit_count = 0
local spiral_angle = 0fx
local ring_offset = 0fx
local move_angle = 0fx
local bob_angle = 0fx
local core_angle = 0fx
local ring_angle = 0fx
local boss_x = center_x
local boss_y = 650fx
local phase_colors = {0x00ffffff,0xffff00ff,0xff0000ff}
local bullet_color = phase_colors[1]

local boss = pewpew.new_customizable_entity(boss_x,boss_y)
pewpew.customizable_entity_set_mesh(boss,"/dynamic/boss.lua",0)
pewpew.entity_set_radius(boss,45fx)
pewpew.customizable_entity_set_visibility_radius(boss,70fx)
pewpew.customizable_entity_set_position_interpolation(boss,true)
pewpew.customizable_entity_set_mesh_color(boss,bullet_color)

local ring_a = pewpew.new_customizable_entity(boss_x,boss_y)
pewpew.customizable_entity_set_mesh(ring_a,"/dynamic/boss.lua",1)
pewpew.customizable_entity_set_visibility_radius(ring_a,60fx)
pewpew.customizable_entity_set_position_interpolation(ring_a,true)
pewpew.customizable_entity_set_mesh_color(ring_a,bullet_color)

local ring_b = pewpew.new_customizable_entity(boss_x,boss_y)
pewpew.customizable_entity_set_mesh(ring_b,"/dynamic/boss.lua",2)
pewpew.customizable_entity_set_visibility_radius(ring_b,50fx)
pewpew.customizable_entity_set_position_interpolation(ring_b,true)
pewpew.customizable_entity_set_mesh_color(ring_b,bullet_color)

local function set_phase_color()
  bullet_color = phase_colors[phase]
  pewpew.customizable_entity_set_mesh_color(boss,bullet_color)
  pewpew.customizable_entity_set_mesh_color(ring_a,bullet_color)
  pewpew.customizable_entity_set_mesh_color(ring_b,bullet_color)
end

local function enter_phase(new_phase)
  phase = new_phase
  transition = 45
  set_phase_color()
  pewpew.play_sound("/dynamic/sounds.lua",1,boss_x,boss_y)
  pewpew.new_floating_message(boss_x,boss_y+80fx,"PHASE "..phase,{scale = 2fx,ticks_before_fade = 60})
end

local function kill_boss()
  dead = true
  death_timer = 90
  pewpew.customizable_entity_start_exploding(boss,60)
  pewpew.entity_destroy(ring_a)
  pewpew.entity_destroy(ring_b)
  pewpew.create_explosion(boss_x,boss_y,0xffffffff,3fx,100)
  pewpew.play_sound("/dynamic/sounds.lua",2,boss_x,boss_y)
  pewpew.increase_score_of_player(0,5000)
  pewpew.new_floating_message(center_x,center_y,"WARDEN DOWN",{scale = 3fx,ticks_before_fade = 90})
end

local function boss_weapon_hit(entity_id,player_index,weapon_type,x,y)
  if dead then
    return false
  end
  hp = hp-1
  hit_count = hit_count+1
  pewpew.increase_score_of_player(player_index,5)
  if hit_count%6 == 0 then
    pewpew.create_explosion(boss_x,boss_y,bullet_color,1fx,12)
  end
  if hp <= 0 then
    kill_boss()
  elseif hp <= 150 and phase < 3 then
    enter_phase(3)
  elseif hp <= 300 and phase < 2 then
    enter_phase(2)
  end
  return true
end

local function boss_player_hit(entity_id,player_index,ship_entity_id)
  if dead then
    return
  end
  if contact_cd > 0 then
    return
  end
  contact_cd = 30
  pewpew.add_damage_to_player_ship(ship_entity_id,1)
  pewpew.create_explosion(boss_x,boss_y,0xff0000ff,1fx,20)
end

pewpew.customizable_entity_set_weapon_collision_callback(boss,boss_weapon_hit)
pewpew.customizable_entity_set_player_collision_callback(boss,boss_player_hit)

local function bullet_count_ok()
  return pewpew.get_entity_count(pewpew.EntityType.MOTHERSHIP_BULLET) < 220
end

local function fire(angle,speed,large)
  if not bullet_count_ok() then
    return
  end
  pewpew.new_mothership_bullet(boss_x,boss_y,angle,speed,bullet_color,large)
end

local function fire_spiral(arms,step_angle,speed)
  spiral_angle = spiral_angle+step_angle
  for i = 0,arms-1 do
    fire(spiral_angle+tau*fmath.from_fraction(i,arms),speed,false)
  end
end

local function fire_ring(count,speed)
  ring_offset = ring_offset+tau/64fx
  for i = 0,count-1 do
    fire(ring_offset+tau*fmath.from_fraction(i,count),speed,false)
  end
end

local function fire_aimed(count,spread_div,speed,large)
  if not pewpew.entity_get_is_alive(ship_id) then
    return
  end
  local px,py = pewpew.entity_get_position(ship_id)
  local base = fmath.atan2(py-boss_y,px-boss_x)
  for i = 0,count-1 do
    local offset_num = i*2-(count-1)
    fire(base+tau*fmath.from_fraction(offset_num,spread_div),speed,large)
  end
end

local function move_boss()
  local amplitude = 180fx
  local move_step = tau/300fx
  local bob_amp = 20fx
  if phase == 2 then
    amplitude = 240fx
    move_step = tau/240fx
    bob_amp = 30fx
  elseif phase == 3 then
    amplitude = 280fx
    move_step = tau/180fx
    bob_amp = 40fx
  end
  move_angle = move_angle+move_step
  bob_angle = bob_angle+tau/120fx
  local s,c = fmath.sincos(move_angle)
  local bs,bc = fmath.sincos(bob_angle)
  boss_x = center_x+s*amplitude
  boss_y = 650fx+bs*bob_amp
  pewpew.entity_set_position(boss,boss_x,boss_y)
  pewpew.entity_set_position(ring_a,boss_x,boss_y)
  pewpew.entity_set_position(ring_b,boss_x,boss_y)
end

local function rotate_boss()
  core_angle = core_angle+tau/360fx
  ring_angle = ring_angle+tau/180fx
  pewpew.customizable_entity_set_mesh_angle(boss,core_angle,0fx,0fx,1fx)
  pewpew.customizable_entity_set_mesh_angle(ring_a,ring_angle,0fx,0fx,1fx)
  pewpew.customizable_entity_set_mesh_angle(ring_b,-ring_angle,0fx,0fx,1fx)
  local pulse_s,pulse_c = fmath.sincos(bob_angle)
  local scale = 1fx+pulse_s/10fx
  pewpew.customizable_entity_set_mesh_scale(boss,scale)
end

local function boss_attack()
  if transition > 0 then
    return
  end
  if phase == 1 then
    if time%5 == 0 then
      fire_spiral(2,tau/28fx,5fx)
    end
    if time%100 == 0 then
      fire_ring(12,4fx)
    end
  elseif phase == 2 then
    if time%6 == 0 then
      fire_spiral(3,tau/32fx,6fx)
    end
    if time%35 == 0 then
      fire_aimed(5,48,6fx,false)
    end
    if time%120 == 0 then
      fire_ring(16,5fx)
    end
  else
    if time%4 == 0 then
      fire_spiral(3,tau/24fx,6fx)
    end
    if time%25 == 0 then
      fire_aimed(3,64,8fx,true)
    end
    if time%80 == 0 then
      fire_ring(20,6fx)
    end
  end
end

local function update_hud()
  local line = "Hex Warden  HP "..hp.."/"..max_hp.."  Phase "..phase
  if dead then
    line = "Hex Warden defeated"
  end
  pewpew.configure_player_hud(0,{top_left_line = line})
end

function level_tick()
  time = time+1
  if contact_cd > 0 then
    contact_cd = contact_cd-1
  end
  if dead then
    death_timer = death_timer-1
    if death_timer%12 == 0 then
      local ox = fmath.random_fixedpoint(-60fx,60fx)
      local oy = fmath.random_fixedpoint(-60fx,60fx)
      pewpew.create_explosion(boss_x+ox,boss_y+oy,bullet_color,1fx,24)
    end
    if death_timer <= 0 then
      pewpew.stop_game()
    end
    update_hud()
    return
  end
  if transition > 0 then
    transition = transition-1
    if transition%6 < 3 then
      pewpew.customizable_entity_set_mesh_color(boss,0xffffffff)
    else
      pewpew.customizable_entity_set_mesh_color(boss,bullet_color)
    end
  end
  move_boss()
  rotate_boss()
  boss_attack()
  if time%10 == 0 then
    update_hud()
  end
  pewpew.increase_score_of_player(0,1)
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] == true then
    pewpew.stop_game()
  end
end

pewpew.add_update_callback(level_tick)
update_hud()
pewpew.new_floating_message(center_x,center_y,"HEX WARDEN",{scale = 3fx,ticks_before_fade = 90})
pewpew.play_sound("/dynamic/sounds.lua",0,boss_x,boss_y)
