local true_width, true_height = 1536fx, 768fx
local level_width, level_height = 2fx * true_width + 100fx, 2fx * true_height + 100fx

local range_x, range_y = true_width / 2fx, true_height / 2fx
local center_x, center_y = level_width / 2fx, level_height / 2fx
local player_right_edge = center_x + range_x
local player_left_edge = center_x - range_x
local player_top_edge = center_y + range_y
local player_bottom_edge = center_y - range_y

pewpew.set_level_size(level_width, level_height)

local rdots = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(rdots,"/dynamic/random_dots.lua",0)
local rdotss = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(rdotss,"/dynamic/random_dots_2.lua",0)
pewpew.customizable_entity_configure_music_response(rdotss,{color_start = 0xffffff35,color_end = 0xffffffc5})

local function random_position()
  return fmath.random_fixedpoint(0fx,level_width),fmath.random_fixedpoint(0fx,level_height)
end

local player_index = 0
local ship_id = pewpew.new_player_ship(center_x, center_y, player_index)
pewpew.configure_player(player_index, {shield = 3, camera_distance = 50fx})
pewpew.configure_player_ship_weapon(ship_id, {cannon = pewpew.CannonType.DOUBLE, frequency = pewpew.CannonFrequency.FREQ_10})

pewpew.configure_player(0,{move_joystick_color = 0xffffffb0})
pewpew.configure_player(0,{shoot_joystick_color = 0xffffffb0})

local px, py = pewpew.entity_get_position(ship_id)

function loop_player()
  local has_player_moved = false
  local dx, dy = 0fx, 0fx
  if px > player_right_edge then
    dx = -true_width
    has_player_moved = true
  elseif px < player_left_edge then
    dx = true_width
    has_player_moved = true
  end
  if py > player_top_edge then
    dy = -true_height
    has_player_moved = true
  elseif py < player_bottom_edge then
    dy = true_height
    has_player_moved = true
  end
  if has_player_moved then
    local entities = pewpew.get_all_entities()
    for i = 1, #entities do
      local entity_id = entities[i]
      local ex, ey = pewpew.entity_get_position(entity_id)
      ex = ex + dx
      ey = ey + dy
      pewpew.entity_set_position(entity_id, ex, ey)
    end
  end
  if pewpew.entity_get_is_alive(ship_id) then
    px, py = pewpew.entity_get_position(ship_id)
  end
end
function loop_entities()
  local entities = pewpew.get_all_entities()
  local right_edge = px + range_x
  local left_edge = px - range_x
  local top_edge = py + range_y
  local bottom_edge = py - range_y
  for i = 1, #entities do
    local entity = entities[i]
    local ex, ey = pewpew.entity_get_position(entity)
    if ex > right_edge then
      ex = ex - true_width
    elseif ex < left_edge then
      ex = ex + true_width
    end
    if ey > top_edge then
      ey = ey - true_height
    elseif ey < bottom_edge then
      ey = ey + true_height
    end
    pewpew.entity_set_position(entity, ex, ey)
  end
end

local time = -1
local wave = 0
local bonus = -50
pewpew.add_update_callback(function()
  time = time + 1
  if pewpew.entity_get_is_alive(ship_id) then
    px, py = pewpew.entity_get_position(ship_id)
    if pewpew.get_entity_count(pewpew.EntityType.ASTEROID) == 0 then
      wave = wave + 1
      bonus = bonus + 50
      local rand_ufo = fmath.random_int(1,3)
      local rand_inr = fmath.random_int(1,3)
      local delta_entity_number = (wave - 1) // 3
      if wave % 2 == 1 then
        local x, y = random_position()
        pewpew.new_bonus(x, y, pewpew.BonusType.SHIELD, {number_of_shields = 1})
      end
      if wave % 4 == 1 then
        pewpew.new_bonus(500fx, -100fx, pewpew.BonusType.WEAPON, {cannon = pewpew.CannonType.TRIPLE, frequency = pewpew.CannonFrequency.FREQ_15, weapon_duration = 100})
      end

      if wave % 3 == 1 then
        pewpew.new_floating_message(center_x, center_y, "Round "..wave, {scale = 4fx, dz = 0fx, ticks_before_fade = 60, is_optional = false})
        pewpew.new_floating_message(center_x, center_y - 100fx, "Bonus: "..bonus, {scale = 1fx, dz = 0fx, ticks_before_fade = 60, is_optional = false})
        pewpew.increase_score_of_player(0,bonus)
        local x = center_x - range_x
        local y = center_y
        if rand_ufo == 1 then
          local ufo=pewpew.new_ufo(x,y,3fx) pewpew.ufo_set_enable_collisions_with_walls(ufo,true)
        end
        if rand_inr == 1 then
          pewpew.new_inertiac(x,y,1fx,1fx)
        end
        for i = 1, 4 + 3 * delta_entity_number do
          pewpew.new_asteroid(x, y)
        end

      elseif wave % 3 == 2 then
        pewpew.new_floating_message(center_x, center_y, "#00ff00ffRound "..wave, {scale = 4fx, dz = 0fx, ticks_before_fade = 60, is_optional = false})
        pewpew.new_floating_message(center_x, center_y - 100fx, "Bonus: "..bonus, {scale = 1fx, dz = 0fx, ticks_before_fade = 60, is_optional = false})
        pewpew.increase_score_of_player(0,bonus)
        local x = center_x - range_x
        local y = center_y
        if rand_ufo == 1 then
          local ufo=pewpew.new_ufo(x,y,3fx) pewpew.ufo_set_enable_collisions_with_walls(ufo,true)
        end
        if rand_inr == 1 then
          pewpew.new_inertiac(x,y,1fx,1fx)
        end
        for i = 1, 3 + 2 * delta_entity_number do
          pewpew.new_asteroid(x, y)
        end
        for i = 1, 1 + 2 * delta_entity_number do
          pewpew.new_mothership(x, y, pewpew.MothershipType.SIX_CORNERS, fmath.random_fixedpoint(0fx, fmath.tau()))
        end

      else
        pewpew.new_floating_message(center_x, center_y, "#ffff00ffRound "..wave, {scale = 4fx, dz = 0fx, ticks_before_fade = 60, is_optional = false})
        pewpew.new_floating_message(center_x, center_y - 100fx, "Bonus: "..bonus, {scale = 1fx, dz = 0fx, ticks_before_fade = 60, is_optional = false})
        pewpew.increase_score_of_player(0,bonus)
        local ast_x = center_x - range_x
        local ast_y = center_y
        if rand_ufo == 1 then
          local ufo=pewpew.new_ufo(x,y,3fx) pewpew.ufo_set_enable_collisions_with_walls(ufo,true)
        end
        if rand_inr == 1 then
          pewpew.new_inertiac(x,y,1fx,1fx)
        end
        for i = 1, 3 + 2 * delta_entity_number do
          pewpew.new_asteroid(ast_x, ast_y)
        end
        for dx = -80fx * (delta_entity_number + 1), 80fx * (delta_entity_number + 1), 40fx do
          pewpew.new_rolling_cube(center_x + dx, ast_y - 80fx)
        end

      end
    end
  end
  loop_player()
  loop_entities()
  if pewpew.get_player_configuration(player_index)["has_lost"] then
    pewpew.stop_game()
  end
end)