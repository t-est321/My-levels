local width = 6000fx
local height = 6000fx
pewpew.set_level_size(width, height)
local background = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(background, "/dynamic/graphic.lua", 0)
local id = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(id, "/dynamic/level_graphics.lua", 0)
local ship = pewpew.new_player_ship(25fx, 25fx, 0)
pewpew.configure_player_ship_weapon(ship, {frequency = pewpew.CannonFrequency.FREQ_15, cannon = pewpew.CannonType.TRIPLE})
pewpew.configure_player(0, {shield = 10, camera_distance = -350fx, camera_rotation_x_axis = fmath.tau() / -55fx})
local function random_position()
  return fmath.random_fixedpoint(0fx, 6000fx), fmath.random_fixedpoint(0fx, 6000fx)
end
local time = 0
pewpew.add_update_callback(function()
 time = time + 1
 local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if time %10 == 0 then
    local x, y = random_position()
    pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,1100)
  end
  if time %30 == 0 then
    local x, y = random_position()
    pewpew.new_baf_red(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,1100)
  end
  if time %20 == 0 then
    local x, y = random_position()
    pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,1100)
  end
  if time %100 == 0 then
    local x, y = random_position()
    pewpew.new_mothership(x, y, pewpew.MothershipType.FIVE_CORNERS, fmath.random_fixedpoint(0fx, fmath.tau()))
    pewpew.new_asteroid(x, y)
    local x, y = random_position()
    pewpew.new_wary(x, y)
  end
  if time %285 == 0 then
    local x, y = random_position()
    pewpew.new_rolling_cube(x,y)
  end
  if time %125 == 0 then
    local x, y = random_position()
    pewpew.new_crowder(x,y)
  end
  if time %237 == 0 then
    local x, y = random_position()
    pewpew.new_kamikaze(x,y,0fx)
  end
  if time %50 == 0 then
    local x, y = random_position()
    pewpew.new_spiny(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx)
  end
  if time % 300 == 0 then
    local x, y = random_position()
    pewpew.new_inertiac(x, y, 13fx/10fx, fmath.random_fixedpoint(0fx,fmath.tau()))
    pewpew.new_mothership(x, y, pewpew.MothershipType.THREE_CORNERS, fmath.random_fixedpoint(0fx,fmath.tau()))
  end
  if time % 1000 == 0 then
    local x, y = random_position()
    pewpew.new_bonus(x, y, pewpew.BonusType.SHIELD, {number_of_shields = 2})  end
  if time % 200 == 0 then
    local x, y = random_position()
    local ufo=pewpew.new_ufo(x, y, 7fx) pewpew.ufo_set_enable_collisions_with_walls(ufo, true)
    for count = 1, 10 do
      local x, y = random_position()
      pewpew.new_brownian(x, y)
    end
  end
  if time %250 == 0 then
    local x, y = random_position()
    pewpew.new_super_mothership(x, y, pewpew.MothershipType.THREE_CORNERS, fmath.random_fixedpoint(0fx,fmath.tau()))
  end
  if time %1250 == 0 then
    local x, y = random_position()
    pewpew.new_bomb(x, y, 2)
    pewpew.new_bonus(x, y, pewpew.BonusType.WEAPON, {cannon = pewpew.CannonType.TRIPLE, frequency = pewpew.CannonFrequency.FREQ_30, weapon_duration = 175})
  end
end)