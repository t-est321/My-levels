local w = 1350fx
local h = 1350fx
pewpew.set_level_size(w,h)
local cx = w/2fx
local cy = h/2fx
local ship = pewpew.new_player_ship(cx,cy,0)
pewpew.configure_player_ship_weapon(ship,{cannon = pewpew.CannonType.SINGLE,frequency = pewpew.CannonFrequency.FREQ_7_5})
pewpew.configure_player(0,{shield = 3,camera_distance = -416fx})

local center_x = w/2fx
local center_y = h/2fx
local arena_radius = 600fx

local sides = 40
for i = 0,sides-1 do
  local a1 = fmath.tau()*fmath.to_fixedpoint(i)/fmath.to_fixedpoint(sides)
  local a2 = fmath.tau()*fmath.to_fixedpoint(i+1)/fmath.to_fixedpoint(sides)
  local dy1,dx1 = fmath.sincos(a1)
  local dy2,dx2 = fmath.sincos(a2)
  pewpew.add_wall(center_x+dx1*arena_radius,center_y+dy1*arena_radius,center_x+dx2*arena_radius,center_y+dy2*arena_radius)
end

local border_bg = pewpew.new_customizable_entity(center_x,center_y)
pewpew.customizable_entity_set_mesh(border_bg,"/dynamic/border.lua",0)
pewpew.customizable_entity_set_mesh_z(border_bg,0fx)
pewpew.customizable_entity_set_mesh_scale(border_bg,6fx)
pewpew.customizable_entity_set_mesh_color(border_bg,0xff0055ff)

local bg = {}
for i = 1,40 do
  local id = pewpew.new_customizable_entity(cx,cy)
  local m_idx = i%2
  pewpew.customizable_entity_set_mesh(id,"/dynamic/bg.lua",m_idx)
  local z = fmath.to_fixedpoint(-100-i*40)
  pewpew.customizable_entity_set_mesh_z(id,z)
  pewpew.customizable_entity_set_mesh_scale(id,fmath.to_fixedpoint(i*4))
  local rot = fmath.from_fraction(3+i%5,1000)
  if i%2 == 0 then
    rot = fmath.to_fixedpoint(0)-rot
  end
  local color = 0x12ffffdd
  if i%3 == 0 then color = 0xff12ffdd end
  if i%3 == 1 then color = 0x12ea09dd end
  pewpew.customizable_entity_set_mesh_color(id,color)
  table.insert(bg,{id = id,rot = rot,base_z = z,off = i})
end

local t = 0
local game_over_timer = -1

local function get_edge()
  local random_angle = fmath.random_fixedpoint(0fx,fmath.tau())
  local s,c = fmath.sincos(random_angle)
  local spawn_radius = arena_radius-5fx
  local x = center_x+c*spawn_radius
  local y = center_y+s*spawn_radius
  local a = fmath.atan2(cy-y,cx-x)
  return x,y,a
end



pewpew.add_update_callback(function()
  t = t+1
  local entities_list = pewpew.get_all_entities()
  for _,entity_id in ipairs(entities_list) do
    if pewpew.get_entity_type(entity_id) == pewpew.EntityType.POINTONIUM then
      pewpew.entity_destroy(entity_id)
    end
  end
  local p_conf = pewpew.get_player_configuration(0)
  if p_conf.has_lost then
    if game_over_timer == -1 then game_over_timer = 30 end
    game_over_timer = game_over_timer-1
    if game_over_timer == 0 then pewpew.stop_game() end
  end

  pewpew.customizable_entity_add_rotation_to_mesh(border_bg,fmath.from_fraction(1,500),0fx,0fx,1fx)

  for i,layer in ipairs(bg) do
    pewpew.customizable_entity_add_rotation_to_mesh(layer.id,layer.rot,0fx,0fx,1fx)
    local s,c = fmath.sincos(fmath.from_fraction(t+layer.off*10,80))
    pewpew.customizable_entity_set_mesh_z(layer.id,layer.base_z+s*40fx)
  end

  if t%20 == 0 then
    local x,y,a = get_edge()
    pewpew.new_spiny(x,y,a,fmath.from_fraction(15,10))
  end
  if t > 400 and t%50 == 0 then
    local x,y,a = get_edge()
    pewpew.new_baf_blue(x,y,a,fmath.random_fixedpoint(9fx,12fx),-1)
  end
  if t > 1000 and t%80 == 0 then
    local x,y,a = get_edge()
    pewpew.new_rolling_sphere(x,y,a,fmath.random_fixedpoint(6fx,8fx))
  end
  if t > 1350 and t%300 == 0 then
    local random_angle = fmath.random_fixedpoint(0fx,fmath.tau())
    local s,c = fmath.sincos(random_angle)
    local spawn_radius = arena_radius-5fx
    local rx = center_x+c*spawn_radius
    local ry = center_y+s*spawn_radius
    local a = get_edge()
    pewpew.new_mothership(rx,ry,pewpew.MothershipType.FIVE_CORNERS,a)
  end
  if t == 3000 then
    pewpew.configure_player_ship_weapon(ship,{cannon = pewpew.CannonType.TRIPLE,frequency = pewpew.CannonFrequency.FREQ_10})
    local px,py = pewpew.entity_get_position(ship)
    pewpew.new_floating_message(px,py,"END OF LIFE",{scale = 1fx/2fx+1fx,ticks_before_fade = 120})
    local x,y,a = get_edge()
    pewpew.new_super_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,a)
  end

  if t > 3000 then
    if t%30 == 0 then
      local x,y,a = get_edge()
      pewpew.new_kamikaze(x,y,a)
    end
    if t%100 == 0 then
      local x,y,a = get_edge()
      pewpew.new_baf_red(x,y,a,fmath.random_fixedpoint(10fx,13fx),-1)
    end
    if t%650 == 0 then
      local x,y,a = get_edge()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,a)
    end
    if t%825 == 0 then
      local x,y,a = get_edge()
      pewpew.new_super_mothership(x,y,pewpew.MothershipType.SEVEN_CORNERS,a)
    end
  end

  if t%500 == 0 then
    local random_angle = fmath.random_fixedpoint(0fx,fmath.tau())
    local s,c = fmath.sincos(random_angle)
    local spawn_radius = arena_radius-5fx
    local bx = center_x+c*spawn_radius
    local by = center_y+s*spawn_radius
    local r = fmath.random_int(0,3)
    if r == 0 then
      pewpew.new_bonus(bx,by,pewpew.BonusType.SHIELD,{number_of_shields = 1})
    elseif r == 1 then
      pewpew.new_bonus(bx,by,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.HEMISPHERE,frequency = pewpew.CannonFrequency.FREQ_1,weapon_duration = 200})
    elseif r == 2 then
      pewpew.new_bonus(bx,by,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.HEMISPHERE,frequency = pewpew.CannonFrequency.FREQ_1,weapon_duration = 200})
    else
      pewpew.new_bonus(bx,by,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.LASER,frequency = pewpew.CannonFrequency.FREQ_1,weapon_duration = 200})
    end
  end
end)