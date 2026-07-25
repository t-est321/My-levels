local var = require("/dynamic/variables.lua")
local pew = pewpew
local fm = fmath

local burrets = {}

function burret_update(entity_id)
  local data = burrets[entity_id]
  if data == nil then return end
  local ship = data[5]
  local x,y = pew[var.entity_get_pos](entity_id)
  local speed = data[1]
  if pew[var.entity_alive](ship) == true then
    local px,py = pew[var.entity_get_pos](ship)
    local a = fm[var.atan](py-y,px-x)
    local dy,dx = fm[var.sin_cos](a)
    x = x+dx*speed
    y = y+dy*speed
    pew[var.entity_pos](entity_id,x,y)
    pew[var.entity_mesh_angle](entity_id,a,0fx,0fx,1fx)
  end
  if data[4] > 0 then
    data[4] = data[4]-1
    if data[4] == 0 then
      pew[var.entity_mesh](entity_id,var.root.."burret_graphic"..var.file_end,0)
    end
  end
  if data[6] == true then
    data[6] = false
  end
  if data[7] > 0 then
    data[7] = data[7]-1
  end
  if pew[var.entity_is_destroyed](entity_id) == true then
    burrets[entity_id] = nil
    pew[var.entity_player_collision](entity_id,nil)
    pew[var.entity_weapon_collision](entity_id,nil)
    pew[var.entity_update](entity_id,nil)
    pew[var.entity_wall_collision](entity_id,true,nil)
    pew[var.add_score](0,16)
    pew[var.text]("burret: + 16 score")
  end
end

function burret_collide_with_ship(entity_id,pindex,ship_entity_id)
  pew[var.entity_exploding](entity_id,50)
  local x,y = pew[var.entity_get_pos](entity_id)
  pew[var.floating_msg](x,y,"#24ff2fff16",{[var.scale_xy] = 1fx+1fx/20fx,[var.ticks] = 23,[var.hidden] = true})
  pew[var.damage_ship](ship_entity_id,1)
end

function burret_wall_collision(entity_id)
  local data = burrets[entity_id]
  if data == nil then return end
  if data[7] == 0 then
    local x,y = pew[var.entity_get_pos](entity_id)
    pew[var.explosion](x,y,0x00ffffff,1fx,10)
    data[7] = 3
  else
    data[7] = 3
  end
end

function burret_weapon_collision(entity_id,weapon_description)
  local data = burrets[entity_id]
  pew[var.entity_mesh](entity_id,var.root.."burret_graphic_white"..var.file_end,0)
  data[4] = 2
  if data[2] >= 0 then
    pew[var.add_score](0,4)
  end
  if data[2] == 0 then
    pew[var.entity_exploding](entity_id,35)
    local x,y = pew[var.entity_get_pos](entity_id)
    pew[var.floating_msg](x,y,"#24ff2fff16",{[var.scale_xy] = 1fx+1fx/20fx,[var.ticks] = 23,[var.hidden] = true})
  else
    data[2] = data[2]-1
  end
  return true
end

function burret_new(x,y,target_ship_id)
  local id = pew[var.entity](x,y)
  burrets[id] = {4fx+1fx/2fx,5,0fx,0,target_ship_id,false,0}
  pew[var.entity_mesh](id,var.root.."burret_graphic"..var.file_end,0)
  pew[var.entity_pos_interpolation](id,true)
  pew[var.entity_radius](id,11fx)
  pew[var.entity_spawning](id,5)
  pew[var.entity_hitbox](id,11fx)
  pew[var.entity_weapon_collision](id,burret_weapon_collision)
  pew[var.entity_update](id,burret_update)
  pew[var.entity_player_collision](id,burret_collide_with_ship)
  pew[var.entity_wall_collision](id,true,burret_wall_collision)
end

local pindex = 0
-- var: 24