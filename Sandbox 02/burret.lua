local burrets = {}
function burret_update(entity_id)
  local data = burrets[entity_id]
  if data == nil then return end
  local ship = data[5]
  local x,y = pewpew.entity_get_position(entity_id)
  local speed = data[1]
  if pewpew.entity_get_is_alive(ship) == true then
    local px,py = pewpew.entity_get_position(ship)
    local a = fmath.atan2(py-y,px-x)
    local dy,dx = fmath.sincos(a)
    x = x+dx*speed
    y = y+dy*speed
    pewpew.entity_set_position(entity_id,x,y)
    pewpew.customizable_entity_set_mesh_angle(entity_id,a,0fx,0fx,1fx)
  end
  if data[4] > 0 then
    data[4] = data[4]-1
    if data[4] == 0 then
      pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/burret_graphic.lua",0)
    end
  end
  if pewpew.entity_get_is_started_to_be_destroyed(entity_id) == true then
    burrets[entity_id] = nil
    pewpew.customizable_entity_set_player_collision_callback(entity_id,nil)
    pewpew.customizable_entity_set_weapon_collision_callback(entity_id,nil)
    pewpew.entity_set_update_callback(entity_id,nil)
    pewpew.increase_score_of_player(0,32)
    pewpew.print("burret: + 32 score")
  end
end
function burret_collide_with_ship(entity_id,pindex,ship_entity_id)
  pewpew.customizable_entity_start_exploding(entity_id,50)
  local x,y = pewpew.entity_get_position(entity_id)
  pewpew.new_floating_message(x,y,"#24ff2fff32",{scale = 1fx+1fx/16fx,dz = 1fx,ticks_before_fade = 20,is_optional = true})
  pewpew.add_damage_to_player_ship(ship_entity_id,1)
end
function burret_weapon_collision(entity_id,weapon_description)
  local data = burrets[entity_id]
  pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/burret_graphic_white.lua",0)
  data[4] = 2
  if data[2] >= 0 then
    pewpew.increase_score_of_player(0,8)
  end
  if data[2] == 0 then
    pewpew.customizable_entity_start_exploding(entity_id,35)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.new_floating_message(x,y,"#24ff2fff32",{scale = 1fx+1fx/16fx,dz = 1fx,ticks_before_fade = 23,is_optional = true})
  else
    data[2] = data[2]-1
  end
  return true
end
function burret_new(x,y,target_ship_id)
  local id = pewpew.new_customizable_entity(x,y)
  burrets[id] = {4fx+1fx/2fx,5,0fx,0,target_ship_id}
  pewpew.customizable_entity_set_mesh(id,"/dynamic/burret_graphic.lua",0)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.entity_set_radius(id,11fx)
  pewpew.customizable_entity_set_visibility_radius(id,11fx)
  pewpew.customizable_entity_set_weapon_collision_callback(id,burret_weapon_collision)
  pewpew.entity_set_update_callback(id,burret_update)
  pewpew.customizable_entity_set_player_collision_callback(id,burret_collide_with_ship)
end
local pindex = 0
-- var: 18