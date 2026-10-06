local width = 1000fx
local height = 1000fx
pewpew.set_level_size(width, height)
local ground = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(ground, "/dynamic/background.lua", 0)
local wall3d = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(wall3d, "/dynamic/background_2.lua", 0)
local bg = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(bg, "/dynamic/level_graphics.lua", 0)
pewpew.add_wall(490fx, 490fx, 510fx, 490fx)
pewpew.add_wall(510fx, 490fx, 510fx, 510fx)
pewpew.add_wall(510fx, 510fx, 490fx, 510fx)
pewpew.add_wall(490fx, 510fx, 490fx, 490fx)
pewpew.add_wall(200fx, 500fx, 300fx, 500fx)
pewpew.add_wall(700fx, 500fx, 800fx, 500fx)
pewpew.add_wall(500fx, 200fx, 500fx, 300fx)
pewpew.add_wall(500fx, 700fx, 500fx, 800fx)
local random_count = fmath.random_int(225,445)

local function random_position()
  return fmath.random_fixedpoint(0fx, width), fmath.random_fixedpoint(0fx, height)
end

pewpew.configure_player(0, {shield = 3, camera_distance = -125fx, camera_rotation_x_axis = fmath.tau() / -31fx+1fx/2fx})
local ship = pewpew.new_player_ship(25fx, 25fx, 0)
pewpew.configure_player_ship_weapon(ship, {frequency = pewpew.CannonFrequency.FREQ_5, cannon = pewpew.CannonType.DOUBLE})
local time_counter = pewpew.new_customizable_entity(250fx, 250fx)
pewpew.customizable_entity_set_mesh_scale(time_counter,3fx)
local time_counter2 = pewpew.new_customizable_entity(250fx, 750fx)
pewpew.customizable_entity_set_mesh_scale(time_counter2,3fx)
local time_counter3 = pewpew.new_customizable_entity(750fx, 750fx)
pewpew.customizable_entity_set_mesh_scale(time_counter3,3fx)
local time_counter4 = pewpew.new_customizable_entity(750fx, 250fx)
pewpew.customizable_entity_set_mesh_scale(time_counter4,3fx)
local time = 0
local count = 420
pewpew.add_update_callback(function() -- #ff ff ff ff (RGBA)
  time = time + 1

  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] == true then
    pewpew.stop_game()
  end
  if time %25 == 0 then
    local x, y = random_position()
    pewpew.new_rolling_cube(x, y)
  end
  if time %10 == 0 then
    pewpew.increase_score_of_player(0, 1)
  end
  if time %30 == 0 then
    count = count - 1
  end
  if time %3750 == 0 then
    local x, y = random_position()
    pewpew.create_explosion(x, y, 0xff0000ff, 1fx, 20)
    pewpew.new_rolling_sphere(x, y, fmath.random_fixedpoint(0fx,fmath.tau()), 20fx)
    pewpew.play_ambient_sound("/dynamic/sounds_level.lua", 0)
  end
  if time %1135 == 0 then
    pewpew.play_sound("/dynamic/sounds_level.lua", 1, 500fx, 500fx)
    for count = 1, 25 do
      local x, y = random_position()
      pewpew.new_brownian(x, y)
    end
  end
  if time %4000 == 0 then
    local x, y = random_position()
    pewpew.new_bonus(x, y, pewpew.BonusType.SHIELD, {number_of_shields = 1})
  end
  if time %2750 == 0 then
    local x, y = random_position()
    pewpew.new_bonus(x, y, pewpew.BonusType.WEAPON, {cannon = pewpew.CannonType.SINGLE, frequency = pewpew.CannonFrequency.FREQ_30, weapon_duration = 125})
    pewpew.new_pointonium(x, y, 128)
  end
  if pewpew.entity_get_is_alive(time_counter) then
    if count >= 0 then
      pewpew.customizable_entity_set_string(time_counter, "#ffaa77dd" .. count)
      pewpew.customizable_entity_set_string(time_counter2, "#ffaa66dd" .. count)
      pewpew.customizable_entity_set_string(time_counter3, "#ffaa56dd" .. count)
      pewpew.customizable_entity_set_string(time_counter4, "#ffaa66cc" .. count)
    end
    if count == -1 then
      local shield_count = pewpew.get_player_configuration(0).shield
      pewpew.increase_score_of_player(0,shield_count*random_count)
      pewpew.entity_destroy(time_counter)
      pewpew.entity_destroy(time_counter2)
      pewpew.entity_destroy(time_counter3)
      pewpew.entity_destroy(time_counter4)
      pewpew.stop_game()
    end
  end
end)