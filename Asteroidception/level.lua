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
pewpew.customizable_entity_set_mesh(rdots, "/dynamic/random_dots.lua", 0)

local function random_position()
  return fmath.random_fixedpoint(0fx, level_width), fmath.random_fixedpoint(0fx, level_height)
end

local player_index = 0
local ship_id = pewpew.new_player_ship(center_x, center_y+100fx, player_index)
pewpew.configure_player(player_index, {shield = 2, camera_distance = -200fx})
pewpew.configure_player_ship_weapon(ship_id, {cannon = pewpew.CannonType.DOUBLE, frequency = pewpew.CannonFrequency.FREQ_10})

pewpew.configure_player(0,{move_joystick_color = 0xffff00b0})

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
pewpew.add_update_callback(function()
  time = time + 1
  if pewpew.entity_get_is_alive(ship_id) then
 -- pewpew.configure_player_hud(0,{top_left_line = "time: "..time})
    px, py = pewpew.entity_get_position(ship_id)
    if pewpew.get_entity_count(pewpew.EntityType.MOTHERSHIP) == 0 then
      wave = wave + 1
      local rand_war = fmath.random_int(1, 5)-- Chance of appearance:20%
      local rand_cub = fmath.random_int(1, 2)-- Chance of appearance:50%
      local delta_entity_number = (wave - 1) // 5
      if wave % 3 == 0 then
        local x = center_x - range_x
        local y = center_y
        pewpew.new_inertiac(x,y,1fx,fmath.random_fixedpoint(0fx,fmath.tau()))
      end
      if wave % 5 == 1 then
        pewpew.new_floating_message(center_x, center_y, "#ffff32ffRo#ffdd32ffun#ffbb32ffd "..wave, {scale = 3fx, dz = -1fx, ticks_before_fade = 115, is_optional = false})
        local x = center_x - range_x
        local y = center_y
        if rand_war == 1 then
          pewpew.new_wary(x, y)
        end
        if rand_cub == 1 then
          pewpew.new_floating_message(x, y, "#ff3232ff-600", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,-600)
          for count = 1,10 do
            pewpew.new_rolling_cube(x+fmath.random_fixedpoint(-30fx,30fx), y+fmath.random_fixedpoint(-30fx,30fx))
          end
        end
        if rand_cub == 2 then
          pewpew.new_floating_message(x, y, "#32ff32ff+250", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,250)
        end
        for i = 1, 4 + 3 * delta_entity_number do
          pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
          pewpew.new_baf(x, y, fmath.random_fixedpoint(-2fx,2fx), 7fx, 1105)
        end
        for dx = -180fx * (delta_entity_number + 1), 80fx * (delta_entity_number + 1), 12fx do
          pewpew.new_baf(center_x + dx, y - 80fx, fmath.random_fixedpoint(-2fx,2fx), 7fx, -1)
        end
        local x, y = random_position()
        pewpew.new_bonus(x, y, pewpew.BonusType.SHIELD, {number_of_shields = 1})

      elseif wave % 5 == 2 then
        pewpew.new_floating_message(center_x, center_y, "#ff0000ffRou#00aaffffnd "..wave, {scale = 3fx, dz = -1fx, ticks_before_fade = 115, is_optional = false})
        local x = center_x - range_x
        local y = center_y
        if rand_war == 1 then
          pewpew.new_wary(x, y)
        end
        if rand_cub == 1 then
          pewpew.new_floating_message(x, y, "#ff3232ff-710", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,-710)
          for count = 1,14 do
            pewpew.new_rolling_cube(x+fmath.random_fixedpoint(-30fx,30fx), y+fmath.random_fixedpoint(-30fx,30fx))
          end
        end
        if rand_cub == 2 then
          pewpew.new_floating_message(x, y, "#32ff32ff+305", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,305)
        end
        for dx = -140fx * (delta_entity_number + 1), 80fx * (delta_entity_number + 1), 20fx do
          pewpew.new_baf_red(center_x + dx, y - 80fx, fmath.random_fixedpoint(-2fx,2fx), 7fx, -1)
        end
        for dx = -80fx * (delta_entity_number + 1), 80fx * (delta_entity_number + 1), 15fx do
          pewpew.new_baf_blue(center_x + dx, y - 80fx, fmath.random_fixedpoint(-2fx,2fx), 7fx, -1)
        end
        for i = 1, 4 + 3 * delta_entity_number do
          pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
        end

      elseif wave % 5 == 3 then
        pewpew.new_floating_message(center_x, center_y, "#ff9900ffRo#ffbb00ffun#ffdd00ffd "..wave, {scale = 3fx, dz = -1fx, ticks_before_fade = 115, is_optional = false})
        local x = center_x - range_x
        local y = center_y
        if rand_war == 1 then
          pewpew.new_wary(x, y)
        end
        if rand_cub == 1 then
          pewpew.new_floating_message(x, y, "#ff3232ff-850", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,-850)
          for count = 1,18 do
            pewpew.new_rolling_cube(x+fmath.random_fixedpoint(-30fx,30fx), y+fmath.random_fixedpoint(-30fx,30fx))
          end
        end
        if rand_cub == 2 then
          pewpew.new_floating_message(x, y, "#32ff32ff+375", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,375)
        end
        for i = 1, 4 + 3 * delta_entity_number do
          pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
        end
        for i = 1, 1 + 1 * delta_entity_number do
          pewpew.new_super_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
        end

      elseif wave % 5 == 4 then
        pewpew.new_floating_message(center_x, center_y, "#12ff12ffRo#12ff64ffun#12ff90ffd "..wave, {scale = 3fx, dz = -1fx, ticks_before_fade = 115, is_optional = false})
        local x = center_x - range_x
        local y = center_y
        if rand_war == 1 then
          pewpew.new_wary(x, y)
        end
        if rand_cub == 1 then
          pewpew.new_floating_message(x, y, "#ff3232ff-950", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,-950)
          for count = 1,20 do
            pewpew.new_rolling_cube(x+fmath.random_fixedpoint(-30fx,30fx), y+fmath.random_fixedpoint(-30fx,30fx))
          end
        end
        if rand_cub == 2 then
          pewpew.new_floating_message(x, y, "#32ff32ff+425", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,425)
        end
        for i = 1, 4 + 3 * delta_entity_number do
          pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
        end
        for i = 1, 2 + 2 * delta_entity_number do
          pewpew.new_mothership(x, y, pewpew.MothershipType.SIX_CORNERS, fmath.random_fixedpoint(0fx, fmath.tau()))
        end

      else
        pewpew.new_floating_message(center_x, center_y, "#ff3232ffRo#ff3232ddun#ff3232bbd "..wave, {scale = 3fx, dz = -1fx, ticks_before_fade = 115, is_optional = false})
        local x = center_x - range_x
        local y = center_y
        if rand_war == 1 then
          pewpew.new_wary(x, y)
        end
        if rand_cub == 1 then
          pewpew.new_floating_message(x, y, "#ff3232ff-1350", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,-1350)
          for count = 1,22 do
            pewpew.new_rolling_cube(x+fmath.random_fixedpoint(-30fx,30fx), y+fmath.random_fixedpoint(-30fx,30fx))
          end
        end
        if rand_cub == 2 then
          pewpew.new_floating_message(x, y, "#32ff32ff+500", {scale = 2fx, dz = 5fx, ticks_before_fade = 60, is_optional = false})
          pewpew.increase_score_of_player(0,500)
        end
        for i = 1, 4 + 3 * delta_entity_number do
          pewpew.new_mothership(x,y,pewpew.MothershipType.FIVE_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
        end
        for i = 1, 1 + 1 * delta_entity_number do
          pewpew.new_mothership(x,y,pewpew.MothershipType.FOUR_CORNERS,fmath.random_fixedpoint(0fx,fmath.tau()))
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