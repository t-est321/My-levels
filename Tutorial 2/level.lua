local boxes = require("/dynamic/box_template.lua")
local constants = require("/dynamic/constants.lua")
function clamp(v, min, max)
  if v < min then
    return min
  elseif v > max then
    return max
  end
  return v
end
local box_outer_mesh_info = {"/dynamic/box_graphics.lua", 0}
local box_inner_mesh_info = {"/dynamic/box_graphics.lua", 1}
local box_outer_mesh_infoo = {"/dynamic/box_graphics_a.lua", 0}
local box_inner_mesh_infoo = {"/dynamic/box_graphics_a.lua", 1}
local w = constants.level_width
local h = constants.level_height
pewpew.set_level_size(w, h)
local function random_position()
  return fmath.random_fixedpoint(0fx, width), fmath.random_fixedpoint(0fx, height)
end
local id = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(id, "/dynamic/level_graphics.lua", 0)
local dots_background = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh(dots_background, "/dynamic/random_dots.lua", 0)
ship = pewpew.new_player_ship(w / 2fx, h / 2fx, 0)
pewpew.configure_player(0, {camera_distance = 256fx, shield = 3})
local time = 0
local mode_shoot = false
local mode_shoot_time = 0
local tutorial_finished = false
local completed_time = 0
local message_id
pewpew.configure_player(0, {shoot_joystick_color = 0, move_joystick_color = 0})
function level_tick()
 time = time + 1
 if time > 40 and time < 105 then
   if time % 10 < 5 then
     pewpew.configure_player(0, {move_joystick_color = 0xff000080})
   else
     pewpew.configure_player(0, {move_joystick_color = 0})
   end
 end
 if time == 120 then
   local positions = {{50fx, 50fx}, {w - 50fx, 50fx}, {50fx, h - 50fx}, {w - 50fx, h - 50fx}, {w - 200fx, 50fx}, {50fx, h - 200fx}, {200fx, h - 50fx}, {w - 50fx, h - 200fx}}
   box_caught = 0
   for i = 1, 8 do
     local x = positions[i][1]
     local y = positions[i][2]
     local box = boxes.new(x, y, box_outer_mesh_info, box_inner_mesh_info,
     function()
       box_caught = box_caught + 1
       pewpew.increase_score_of_player(0,1)
       if box_caught == 8 then
       local xx, yy = random_position()
       local final_box = boxes.new(xx, yy, box_outer_mesh_infoo, box_inner_mesh_infoo,
         function()
           pewpew.increase_score_of_player(0,10)
           mode_shoot = true
           mode_shoot_time = 0
           pewpew.configure_player_ship_weapon(ship, {frequency = 4, cannon = pewpew.CannonType.DOUBLE})
           local up_angle = fmath.tau() * fmath.from_fraction(1, 4)
           local down_angle = fmath.tau() * fmath.from_fraction(3, 4)
           local left_angle = fmath.tau() * fmath.from_fraction(1, 2)
           for x = 50fx, w - 50fx, 100fx do
             pewpew.new_baf(x, h - 50fx, 0fx, 10fx, -1)
             pewpew.new_baf(x, 50fx, left_angle, 10fx, -1)
           end
           for y = 50fx, h - 50fx, 100fx do
             pewpew.new_baf(50fx, y, down_angle, 10fx, -1)
             pewpew.new_baf(w - 50fx, y, up_angle, 10fx, -1)
           end
           for x = 50fx, w - 50fx, 50fx do
             pewpew.new_baf(x, h - 50fx, 10fx, 20fx, -1)
             pewpew.new_baf(x, 50fx, left_angle, 10fx, -1)
           end
           for y = 50fx, h - 50fx, 50fx do
             pewpew.new_baf(50fx, y, down_angle, 10fx, -1)
             pewpew.new_baf(w - 50fx, y, up_angle, 10fx, -1)
           end
         end)
         pewpew.add_arrow_to_player_ship(ship, final_box.handle, 0x00ffff50)
       end
     end
   )
   pewpew.add_arrow_to_player_ship(ship, box.handle, 0x00ffffff)
   end
 end
   if mode_shoot == true or tutorial_finished == true then
     mode_shoot_time = mode_shoot_time + 1
     if mode_shoot_time > 10 and mode_shoot_time < 85 then
       if time % 10 < 5 then
         pewpew.configure_player(0, {shoot_joystick_color = 0xff000080})
       else
         pewpew.configure_player(0, {shoot_joystick_color = 0})
       end
     end
     local index = 1
     if pewpew.get_entity_count(pewpew.EntityType.BAF) == 0 then
       pewpew.set_player_ship_speed(ship, 1fx, 10fx, -1)
       mode_shoot = false
       tutorial_finished = true
       message_id = pewpew.new_customizable_entity(w / 2fx, h / 4fx)
       pewpew.customizable_entity_set_string(message_id, "Tutorial: #00000000Completed")
     end
   end
   if tutorial_finished == true then
     completed_time = completed_time + 1
     if completed_time == 30 then
       pewpew.new_pointonium( 200fx, 200fx, 64)
       pewpew.customizable_entity_set_string(message_id, "Tutorial: #00ff00ffCompleted")
     end
     if completed_time > 120 then
       pewpew.stop_game()
     end
   end
 end
pewpew.add_update_callback(level_tick)