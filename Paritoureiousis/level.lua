local width = 1300fx
local height = 1300fx
pewpew.set_level_size(width,height)

require("/dynamic/logics/particles_at_level.lua")

local bg = pewpew.new_customizable_entity(-100fx,-100fx)
pewpew.customizable_entity_set_mesh(bg,"/dynamic/bg.lua",0)
pewpew.customizable_entity_start_spawning(bg,60)

local gr = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(gr,"/dynamic/bg_ground.lua",0)
pewpew.customizable_entity_start_spawning(gr,120)

local bgde = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(bgde,"/dynamic/bg_decor.lua",0)
pewpew.customizable_entity_start_spawning(bgde,80)
pewpew.customizable_entity_configure_music_response(bgde,{scale_z_start = 1fx,scale_z_end = 1fx+1fx/4fx})

local cub = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(cub,"/dynamic/bg_cubes.lua",0)
pewpew.customizable_entity_start_spawning(cub,80)
pewpew.customizable_entity_configure_music_response(cub,{scale_z_start = 1fx,scale_z_end = 1fx+1fx/2fx})

local stars = pewpew.new_customizable_entity(650fx,650fx)
pewpew.customizable_entity_set_mesh(stars,"/dynamic/stars_2.lua",0)
pewpew.customizable_entity_start_spawning(stars,120)

local star = pewpew.new_customizable_entity(650fx,650fx)
pewpew.customizable_entity_set_mesh(star,"/dynamic/stars.lua",0)
pewpew.customizable_entity_start_spawning(star,110)
pewpew.customizable_entity_set_mesh_angle(star,fmath.tau()/1fx,7fx,5fx,8fx)
pewpew.entity_set_update_callback(star,function(entity_id)
  pewpew.customizable_entity_add_rotation_to_mesh(entity_id,-0.2fx,0fx,0fx,5fx)
end)

local ship = pewpew.new_player_ship(650fx,650fx,0)
local walLen = fmath.random_int(2275,2700)
pewpew.configure_player(0,{camera_distance = -125fx,shield = 3,shoot_joystick_color = 0x51d9bab0,move_joystick_color = 0x51d9bab0})
pewpew.configure_player_ship_wall_trail(ship,{wall_length = walLen})

local function random_position()
  return fmath.random_fixedpoint(0fx,1300fx),fmath.random_fixedpoint(0fx,1300fx)
end

local time = 0
local add_p = pewpew.add_particle
local rnd_f = fmath.random_fixedpoint
local ftau = fmath.tau()
local baf_l1 = 1100
local baf_l2 = 800
local zoneS = 96fx
local baf_s1 = 1fx/2fx+8fx
local baf_s2 = 6fx
local rs_s1 = 6fx
local rs_s2 = 7fx
local rs_s3 = 8fx
local rs_s4 = 9fx
local rs_s5 = 12fx
local rand = rnd_f(0fx,ftau)
local sides = 6
local radius = 256fx
local sides2 = 7
local radius2 = 8fx
local sides3 = 12
local radius3 = 196fx
local old_px = 650fx
local old_py = 650fx
local initialized = false
for i = 0,sides-1 do
  local a1 = ftau*fmath.to_fixedpoint(i)/fmath.to_fixedpoint(sides)
  local dy1,dx1 = fmath.sincos(a1)
  local x1,y1 = pewpew.entity_get_position(ship)
  pewpew.new_crowder(x1+dx1*radius,y1+dy1*radius)
end
-- pewpew.increase_score_of_player(0,6660)
pewpew.configure_player_hud(0,{top_left_line = "Wall trail: "..walLen})
pewpew.add_update_callback(function()
  time = time+1
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if time%30 == 0 then
    pewpew.increase_score_of_player(0,1)
  end
  if time == 4 then
    pewpew.configure_player_hud(0,{top_left_line = " "})
  end
  if pewpew.entity_get_is_alive(ship) then
    local score = pewpew.get_score_of_player(0)
    if score == 6666 then
      pewpew.configure_player_hud(0,{top_left_line = "#ff0000ffYou DIE!"})
      for i = 1,100 do
        local a = rnd_f(0fx,ftau)
        pewpew.new_rolling_sphere(600fx,600fx,a,rs_s5)
      end
      for i = 1,14 do
        pewpew.new_brownian(600fx,600fx)
      end
      pewpew.increase_score_of_player(0,fmath.random_int(-80000,-60000))
    end
    local px,py = pewpew.entity_get_position(ship)
    if initialized then
      local dx = px-old_px
      local dy = py-old_py
      if dx ~= 0fx or dy ~= 0fx then
        add_p(px,py,0fx,-dx+rnd_f(-3fx,3fx),-dy+rnd_f(-3fx,3fx),0fx,0x46a0ffff,64)
        add_p(px,py,0fx,-dx+rnd_f(-3fx,3fx),-dy+rnd_f(-3fx,3fx),0fx,0x2060ccff,48)
        add_p(px,py,0fx,-dx+rnd_f(-4fx,4fx),-dy+rnd_f(-4fx,4fx),0fx,0xffffffff,24)
      end
    else
      initialized = true
    end
    old_px = px
    old_py = py
    level_particles(-275fx,1575fx,-275fx,1575fx,rnd_f(20fx,275fx),rnd_f(-2fx,2fx),rnd_f(-2fx,2fx),rnd_f(-2fx,2fx),0x35ff75ff,0x35ff75ff,57,1)
--[[if time%2 == 0 then
      local x2,y2 = pewpew.entity_get_position(ship)
      for i = 0,sides2-1 do
        local a2 = ftau*fmath.to_fixedpoint(i)/fmath.to_fixedpoint(sides2)
        local dy2,dx2 = fmath.sincos(a2)
        pewpew.add_particle(x2+dx2*radius2,y2+dy2*radius2,0fx,rnd_f(-1fx,1fx),rnd_f(-1fx,1fx),8fx,0x46a0ffff,30)
      end
    end]]
    if time%200 == 0 then
      for i = 1,3 do
        local x,y = random_position()
        pewpew.new_brownian(x,y)
      end
    end
    if time%260 == 0 then
      for i = 1,3 do
        local x,y = random_position()
        local a = rnd_f(0fx,ftau)
        pewpew.new_baf(x,y,a,baf_s1,baf_l1)
      end
    end
    if time%380 == 0 then
      local x,y = random_position()
      local a = rnd_f(0fx,ftau)
      pewpew.new_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,a)
    end
    if time%450 == 0 then
      local x,y = random_position()
      pewpew.new_wary(x,y)
    end
    if time%500 == 0 then
      for i = 1,2 do
        local x,y = random_position()
        local a = rnd_f(0fx,ftau)
        pewpew.new_baf_red(x,y,a,baf_s2,baf_l1)
        pewpew.new_rolling_sphere(x,y,a,rs_s1)
      end
    end
    if time%550 == 0 then
      for i = 1,3 do
        local x,y = random_position()
        pewpew.new_crowder(x,y)
        pewpew.new_baf_blue(x,y,rand,baf_s1,baf_l1)
      end
    end
    if time%580 == 0 then
      for i = 1,6 do
        local x,y = random_position()
        pewpew.new_brownian(x,y)
      end
      for i = 1,2 do
        local x,y = random_position()
        pewpew.new_rolling_cube(x,y)
      end
    end
    if time%600 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,rand)
      pewpew.new_kamikaze(x,y,rand)
    end
    if time%620 == 0 then
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.FOUR_CORNERS,rand)
      local x2,y2 = random_position()
      pewpew.new_mothership(x2,y2,pewpew.MothershipType.SIX_CORNERS,rand)
    end
    if time%650 == 0 then
      for i = 1,4 do
        local x,y = random_position()
        pewpew.new_crowder(x,y)
      end
      local x,y = random_position()
      pewpew.new_wary(x,y)
    end
    if time%700 == 0 then
      local x,y = random_position()
      local a = rnd_f(0fx,ftau)
      pewpew.new_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,a)
      for i = 1,3 do
        local x,y = random_position()
        for i = 1,3 do
          pewpew.new_baf(x,y,a,baf_s1,baf_l2)
        end
      end
    end
    if time%750 == 0 then
      for i = 1,6 do
        local x,y = random_position()
        pewpew.new_baf_red(x,y,rand,baf_s1,baf_l1)
      end
      for i = 1,4 do
        local x,y = random_position()
        pewpew.new_rolling_sphere(x,y,rand,rs_s2)
      end
    end
    if time%800 == 0 then
      local x,y = random_position()
      pewpew.new_rolling_cube(x,y)
      local x3,y3 = pewpew.entity_get_position(ship)
      for i = 0,sides3-1 do
        local ang = rnd_f(0fx,ftau)
        local a3 = ftau*fmath.to_fixedpoint(i)/fmath.to_fixedpoint(sides3)
        local dy3,dx3 = fmath.sincos(a3)
        pewpew.new_baf(x3+dx3*radius3,y3+dy3*radius3,ang,baf_s1,baf_l2)
      end
    end
    if time%900 == 0 then
      for i = 1,8 do
        local x,y = random_position()
        pewpew.new_baf_blue(x,y,rand,baf_s2,baf_l1)
      end
      for i = 1,12 do
        local x,y = random_position()
        pewpew.new_brownian(x,y)
      end
      local x,y = random_position()
      pewpew.new_mothership(x,y,pewpew.MothershipType.THREE_CORNERS,rand)
      local x2,y2 = random_position()
      pewpew.new_mothership(x2,y2,pewpew.MothershipType.FIVE_CORNERS,rand)
    end
    if time%1000 == 0 then
      for i = 1,17 do
        local x,y = random_position()
        pewpew.new_crowder(x,y)
      end
      for i = 1,3 do
        local x,y = random_position()
        pewpew.new_wary(x,y)
      end
      for i = 1,12 do
        local x,y = random_position()
        pewpew.new_baf(x,y,rand,baf_s1,baf_l2)
      end
    end
    if time%1200 == 0 then
      for i = 1,3 do
        local x,y = random_position()
        pewpew.new_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,rand)
      end
      for i = 1,4 do
        local x,y = random_position()
        pewpew.new_rolling_sphere(x,y,rand,rs_s3)
      end
      for i = 1,6 do
        local x,y = random_position()
        pewpew.new_kamikaze(x,y,rand)
      end
    end
    if time%1700 == 0 then
      local x,y = random_position()
      pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
      pewpew.new_weapon_zone(x,y,pewpew.CannonFrequency.FREQ_1,pewpew.CannonType.HEMISPHERE,{radius = zoneS,number_of_sides = 6})
      local x,y = random_position()
      pewpew.new_bonus(x,y,pewpew.BonusType.SPEED,{speed_factor = 1fx+fmath.from_fraction(1,2),speed_offset = fmath.from_fraction(1,7),speed_duration = 256,box_duration = 400})
      local ufo = pewpew.new_ufo(x,y,1fx/2fx+3fx)
      pewpew.ufo_set_enable_collisions_with_walls(ufo,true)
      pewpew.entity_add_mace(ufo,{distance = 120fx,angle = ftau/2fx,rotation_speed = 1fx/12fx,type = pewpew.MaceType.DAMAGE_PLAYERS})
      pewpew.entity_add_mace(ufo,{distance = 120fx,angle = ftau,rotation_speed = 1fx/12fx,type = pewpew.MaceType.DAMAGE_PLAYERS})
    end
    if time%1800 == 0 then
      for i = 1,4 do
        local x,y = random_position()
        local types = {pewpew.MothershipType.THREE_CORNERS,pewpew.MothershipType.FOUR_CORNERS,pewpew.MothershipType.FIVE_CORNERS,pewpew.MothershipType.SIX_CORNERS}
        pewpew.new_mothership(x,y,types[i],rand)
      end
      for i = 1,14 do
        local x,y = random_position()
        pewpew.new_baf_red(x,y,rand,baf_s2,baf_l2)
      end
    end
    if time%2000 == 0 then
      for i = 1,14 do
        local x,y = random_position()
        pewpew.new_brownian(x,y)
      end
      for i = 1,10 do
        local x,y = random_position()
        pewpew.new_rolling_cube(x,y)
      end
      for i = 1,16 do
        local x,y = random_position()
        pewpew.new_crowder(x,y)
      end
    end
    if time%2500 == 0 then
      for i = 1,5 do
        local x,y = random_position()
        pewpew.new_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,rand)
      end
      for i = 1,13 do
        local x,y = random_position()
        pewpew.new_baf_blue(x,y,rand,baf_s2,baf_l2)
      end
      for i = 1,15 do
        local x,y = random_position()
        pewpew.new_baf(x,y,rand,baf_s1,baf_l1)
      end
    end
    if time%3000 == 0 then
      for i = 1,2 do
        local x,y = random_position()
        pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
      end
      local x,y = random_position()
      pewpew.new_weapon_zone(x,y,pewpew.CannonType.DOUBLE,pewpew.CannonFrequency.FREQ_30,{radius = zoneS,number_of_sides = 6})
    end
    if time%3500 == 0 then
      for i = 1,5 do
        local x,y = random_position()
        pewpew.new_kamikaze(x,y,rand)
      end
      for i = 1,3 do
        local x,y = random_position()
        pewpew.new_wary(x,y)
      end
      for i = 1,13 do
        local x,y = random_position()
        pewpew.new_rolling_sphere(x,y,rand,rs_s4)
      end
    end
    if time%5000 == 0 then
      for i = 1,4 do
        local x,y = random_position()
        pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
      end
      local x,y = random_position()
      pewpew.new_weapon_zone(x,y,pewpew.CannonType.HEMISPHERE,pewpew.CannonFrequency.FREQ_3,{radius = zoneS})
    end
    if time%7500 == 0 then
      for i = 1,3 do
        local x,y = random_position()
        pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
        local x2,y2 = random_position()
        pewpew.new_weapon_zone(x2,y2,pewpew.CannonType.HEMISPHERE,pewpew.CannonFrequency.FREQ_7_5,{radius = zoneS})
      end
    end
  end
end)