local CustomEnemy = {}
local data_table = {}
local function update(entity_id)
  local data = data_table[entity_id]
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
      pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/mesh.lua",6)
    end
  end
  if pewpew.entity_get_is_started_to_be_destroyed(entity_id) == true then
    data_table[entity_id] = nil
    pewpew.customizable_entity_set_player_collision_callback(entity_id,nil)
    pewpew.customizable_entity_set_weapon_collision_callback(entity_id,nil)
    pewpew.entity_set_update_callback(entity_id,nil)
    pewpew.increase_score_of_player(0,32)
  end
end
local function collide_with_ship(entity_id,pindex,ship_entity_id)
  pewpew.customizable_entity_start_exploding(entity_id,50)
  local x,y = pewpew.entity_get_position(entity_id)
  pewpew.new_floating_message(x,y,"#24ff2fff32",{scale = 1fx+1fx/16fx,dz = 1fx,ticks_before_fade = 20,is_optional = true})
  pewpew.add_damage_to_player_ship(ship_entity_id,1)
end
local function weapon_collision(entity_id,pindex,w_type,wx,wy)
  local data = data_table[entity_id]
  if data == nil then return false end
  pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/mesh.lua",8)
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
function CustomEnemy.spawn(x,y,target_ship_id)
  local id = pewpew.new_customizable_entity(x,y)
  data_table[id] = {4fx+1fx/2fx,5,0fx,0,target_ship_id}
  pewpew.customizable_entity_set_mesh(id,"/dynamic/mesh.lua",6)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.entity_set_radius(id,11fx)
  pewpew.customizable_entity_set_visibility_radius(id,11fx)
  pewpew.customizable_entity_set_weapon_collision_callback(id,weapon_collision)
  pewpew.entity_set_update_callback(id,update)
  pewpew.customizable_entity_set_player_collision_callback(id,collide_with_ship)
  return id
end
return CustomEnemy