local width = 750fx
local height = 750fx
pewpew.set_level_size(width, height)

local ground = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(ground, "/dynamic/background.lua", 0)
local wall3d = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(wall3d, "/dynamic/background_walls.lua", 0)
local bg = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(bg, "/dynamic/level_graphics.lua", 0)

local function random_position()
  return fmath.random_fixedpoint(0fx, width), fmath.random_fixedpoint(0fx, height)
end

pewpew.configure_player(0, {shield = 4, camera_distance = -375fx, camera_rotation_x_axis = fmath.tau() / -55fx})
local ship = pewpew.new_player_ship(25fx, 25fx, 0)
pewpew.configure_player_ship_weapon(ship, {frequency = pewpew.CannonFrequency.FREQ_3, cannon = pewpew.CannonType.SINGLE})

function clamp(v, min, max)
  return v
end
local time_counter = pewpew.new_customizable_entity(width / 8fx, height / -12fx)
pewpew.customizable_entity_set_mesh_scale(time_counter,3fx)
local time = 0
local count = 180
pewpew.add_update_callback(function() -- #ff ff ff ff (RGBA)
  time = time + 1
  pewpew.increase_score_of_player(0, 1)
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] == true then
    pewpew.stop_game()
  end
  if time % 27 == 0 then
    local x, y = random_position()
    pewpew.new_rolling_sphere(x, y, fmath.random_fixedpoint(0fx,fmath.tau()), 1fx)
    pewpew.play_sound("/dynamic/sounds_level.lua", 0, x, y)
    pewpew.create_explosion(x, y, 0xff0000ee, 1fx, 25)
  end
  if time % 30 == 0 then
    count = count - 1
  end
  if time % 1415 == 0 then
    local x, y = random_position()
    local ufo=pewpew.new_ufo(x, y, 1fx) pewpew.ufo_set_enable_collisions_with_walls(ufo, true)
    for count = 1, 5 do
      pewpew.new_brownian(x, y)
    end
  end
  if pewpew.entity_get_is_alive(time_counter) then
    if count >= 0 then
      pewpew.customizable_entity_set_string(time_counter, "#aa55ddff" .. count)
    end
    if time % 5220 == 0 then
      pewpew.entity_add_mace(ship, {distance = 100fx, angle = 90fx, rotation_speed = 1fx, type = pewpew.MaceType.DAMAGE_ENTITIES})
    end
    if count == -1 then
      local shield_count = pewpew.get_player_configuration(0).shield
      pewpew.increase_score_of_player(0,shield_count*100)
      pewpew.entity_destroy(time_counter)
      pewpew.stop_game()
    end
  end
end)