local tick = 0
local enemies = {}
local wave = 1
local MAX_WAVES = 256
local wave_active = false
local wave_delay = 40
local delay_counter = 0
local spawn_timer = 0
local victory = false
local victory_timer = 0
local EskivBox = require("/dynamic/Eskiv_box.lua")
local CustomEnemy = require("/dynamic/custom_enemy.lua")
pewpew.set_level_size(1200fx,700fx)
local bg1 = pewpew.new_customizable_entity(600fx,350fx)
pewpew.customizable_entity_set_mesh(bg1,"/dynamic/mesh.lua",0)
local bg2 = pewpew.new_customizable_entity(600fx,350fx)
pewpew.customizable_entity_set_mesh(bg2,"/dynamic/mesh.lua",1)
local bg3 = pewpew.new_customizable_entity(600fx,350fx)
pewpew.customizable_entity_set_mesh(bg3,"/dynamic/mesh.lua",2)
local bg4 = pewpew.new_customizable_entity(600fx,350fx)
pewpew.customizable_entity_set_mesh(bg4,"/dynamic/mesh.lua",3)
local bg_glow = pewpew.new_customizable_entity(600fx,350fx)
pewpew.customizable_entity_set_mesh(bg_glow,"/dynamic/mesh.lua",2)
pewpew.customizable_entity_set_mesh_scale(bg_glow,2fx)
pewpew.customizable_entity_set_mesh_color(bg_glow,0x00ffffff)
local bg_bounds = pewpew.new_customizable_entity(600fx,350fx)
pewpew.customizable_entity_set_mesh(bg_bounds,"/dynamic/mesh.lua",5)
local particles = {}
for i = 1,256 do
  local x = fmath.random_fixedpoint(-256fx,1456fx)
  local y = fmath.random_fixedpoint(-256fx,956fx)
  local z = fmath.random_fixedpoint(-30fx,30fx)
  local p = pewpew.new_customizable_entity(x,y)
  pewpew.customizable_entity_set_mesh(p,"/dynamic/mesh.lua",4)
  pewpew.customizable_entity_set_mesh_xyz(p,x,y,z)
  table.insert(particles,{
    id = p,
    x = x,
    y = y,
    z = z,
    vx = fmath.random_fixedpoint(-2fx,2fx),
    vy = fmath.random_fixedpoint(-2fx,2fx),
    vz = fmath.random_fixedpoint(-1fx,1fx)
  })
end
local player = pewpew.new_player_ship(600fx,350fx,0)
pewpew.configure_player_ship_weapon(player,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.DOUBLE})
pewpew.configure_player(0,{shield = 3})
local function random_position()
  return fmath.random_fixedpoint(40fx,1160fx),fmath.random_fixedpoint(40fx,660fx)
end
local function spawn_unique_wave(w)
  local intensity = w/6
  for i = 1,5+intensity do
    local x,y = random_position()
    table.insert(enemies,{id = pewpew.new_asteroid(x,y)})
  end
  if w%2 == 0 then
    for i = 1,3+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),6fx,900)})
    end
  end
  if w%3 == 0 then
    for i = 1,2+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,900)})
      local xx,yy = random_position()
      table.insert(enemies,{id = pewpew.new_baf_blue(xx,yy,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,900)})
    end
  end
  if w%4 == 0 then
    for i = 1,3+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = pewpew.new_kamikaze(x,y,fmath.random_fixedpoint(0fx,fmath.tau()))})
    end
  end
  if w%5 == 0 then
    for i = 1,2+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))})
    end
  end
  if w%6 == 0 then
    for i = 1,2+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = pewpew.new_brownian(x,y)})
    end
  end
  if w%7 == 0 then
    for i = 1,2+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = pewpew.new_crowder(x,y)})
    end
  end
  if w%8 == 0 then
    local x,y = random_position()
    table.insert(enemies,{id = pewpew.new_rolling_cube(x,y)})
    local xx,yy = random_position()
    table.insert(enemies,{id = pewpew.new_rolling_sphere(xx,yy,fmath.random_fixedpoint(0fx,fmath.tau()),8fx)})
  end
  if w%9 == 0 then
    local x,y = random_position()
    table.insert(enemies,{id = pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),1fx/2fx)})
  end
  if w%10 == 0 then
    local x,y = random_position()
    table.insert(enemies,{id = pewpew.new_wary(x,y)})
  end
  if w%12 == 0 then
    local x,y = random_position()
    table.insert(enemies,{id = pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,0fx)})
  end
  if w%16 == 0 then
    local x,y = random_position()
    table.insert(enemies,{id = pewpew.new_super_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,0fx)})
  end
  if w%13 == 0 then
    local x,y = random_position()
    pewpew.new_pointonium(x,y,256)
  end
  if w%5 == 0 then
    local id = EskivBox.spawn(fmath.random_fixedpoint(200fx,1000fx),fmath.random_fixedpoint(200fx,500fx))
    table.insert(enemies,{id = id})
  end
  if w%2 == 1 then
    for i = 1,2+intensity do
      local x,y = random_position()
      table.insert(enemies,{id = CustomEnemy.spawn(x,y,player)})
    end
  end
end
pewpew.add_update_callback(function()
  tick = tick+1
  spawn_timer = spawn_timer+1
  pewpew.entity_set_position(bg1,600fx,350fx)
  pewpew.entity_set_position(bg2,600fx,350fx)
  pewpew.entity_set_position(bg3,600fx,350fx)
  pewpew.entity_set_position(bg4,600fx,350fx)
  pewpew.entity_set_position(bg_glow,600fx,350fx)
  pewpew.entity_set_position(bg_bounds,600fx,350fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg1,fmath.from_fraction(1,500),1fx,0fx,0fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg1,fmath.from_fraction(1,400),0fx,1fx,0fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg1,fmath.from_fraction(1,300),0fx,0fx,1fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg2,-fmath.from_fraction(1,350),0fx,0fx,1fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg3,fmath.from_fraction(1,250),1fx,0fx,0fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg3,fmath.from_fraction(1,200),0fx,1fx,0fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg3,fmath.from_fraction(1,150),0fx,0fx,1fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg4,-fmath.from_fraction(1,180),0fx,0fx,1fx)
  pewpew.customizable_entity_add_rotation_to_mesh(bg_glow,fmath.from_fraction(1,600),0fx,0fx,1fx)
  for _,p in ipairs(particles) do
    p.x = p.x+p.vx
    p.y = p.y+p.vy
    p.z = p.z+p.vz
    if p.x < -256fx then p.x = 1456fx end
    if p.x > 1456fx then p.x = -256fx end
    if p.y < -256fx then p.y = 956fx end
    if p.y > 956fx then p.y = -256fx end
    if p.z < -30fx then p.z = 30fx end
    if p.z > 30fx then p.z = -30fx end
    pewpew.customizable_entity_set_mesh_xyz(p.id,p.x,p.y,p.z)
  end
  if victory then
    victory_timer = victory_timer+1
    if victory_timer%6 == 0 then
      pewpew.create_explosion(600fx,350fx,0x00ffffff,2fx,80)
    end
    if victory_timer > 120 then
      pewpew.stop_game()
    end
    return
  end
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if not wave_active then
    delay_counter = delay_counter+1
    if delay_counter >= wave_delay then
      delay_counter = 0
      if wave > MAX_WAVES then
        victory = true
        pewpew.new_floating_message(600fx,350fx,"VICTORY",{scale = 2fx,ticks_before_fade = 120,is_optional = false})
        local shield_count = pewpew.get_player_configuration(0).shield
        pewpew.increase_score_of_player(0,shield_count*256)
        return
      end
      wave_active = true
      spawn_unique_wave(wave)
      local px,py = pewpew.entity_get_position(player)
      if px ~= nil then
        pewpew.new_floating_message(px,py,"Wave "..wave,{scale = 1fx,ticks_before_fade = 30,is_optional = false})
      else
        pewpew.new_floating_message(600fx,350fx,"Wave "..wave,{scale = 1fx,ticks_before_fade = 30,is_optional = false})
      end
    end
  else
    local alive = 0
    local new_enemies = {}
    for _,e in ipairs(enemies) do
      if pewpew.entity_get_is_alive(e.id) then
        alive = alive+1
        table.insert(new_enemies,e)
      end
    end
    enemies = new_enemies
    if alive == 0 and spawn_timer > 20 then
      wave_active = false
      wave = wave+1
      spawn_timer = 0
    end
  end
  pewpew.configure_player_hud(0,{top_left_line = "Wave "..wave.." / "..MAX_WAVES})
end)