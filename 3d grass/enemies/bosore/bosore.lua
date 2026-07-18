--boss+score
local bosores = {}
function bosore_update(entity_id)
  local data = bosores[entity_id]
  local x,y = pewpew.entity_get_position(entity_id)
  pewpew.customizable_entity_set_mesh_angle(entity_id,data[3],7fx,5fx,8fx)
  data[3] = data[3]+0.1000fx
  pewpew.entity_set_position(entity_id,x,y)

  if data == nil then return end
  if data[4] > 0 then
    data[4] = data[4] - 1
    if data[4] == 0 then
      pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/enemies/bosore/bosore_graphic.lua",0)
    end
  end

  if pewpew.entity_get_is_started_to_be_destroyed(entity_id) == true then
    bosores[entity_id] = nil
    pewpew.customizable_entity_set_player_collision_callback(entity_id,nil)
    pewpew.customizable_entity_set_weapon_collision_callback(entity_id,nil)
    pewpew.entity_set_update_callback(entity_id,nil)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.increase_score_of_player(0,100)
    pewpew.print("bosore: + 100 score")
    for count = 1,2 do
      local ra = fmath.random_fixedpoint(0fx,fmath.tau())
      for i = 1,6 do
        pewpew.new_mothership_bullet(x,y,fmath.from_int(i)+ra,3fx,0xffffffff,false)
      end
    end
    local ranpoint = fmath.random_int(1,3)
    if ranpoint == 1 then
      pewpew.new_pointonium(x,y,128)
      pewpew.new_pointonium(x,y,64)-- all pointonium:192
    elseif ranpoint == 2 then
      pewpew.new_pointonium(x,y,64)
    elseif ranpoint == 3 then
      for i=1,3 do pewpew.new_pointonium(x,y,64) end
    end
  end
end
function bosore_collide_with_ship(entity_id,pindex,ship_entity_id)
  pewpew.customizable_entity_start_exploding(entity_id,50)
  local x,y = pewpew.entity_get_position(entity_id)
  pewpew.play_sound("/dynamic/enemies/bosore/sound.lua",1,x,y)
  pewpew.new_floating_message(x,y,"#24ff2fff100",{scale = 1fx+1fx/4fx,ticks_before_fade = 20,is_optional = true})
  pewpew.add_damage_to_player_ship(ship_entity_id,2)
end
function bosore_weapon_collision(entity_id,weapon_description)
  local data = bosores[entity_id]

  pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/enemies/bosore/bosore_graphic_white.lua",0)
  data[4] = 2

  if data[2] >= 0 then
    local ra = fmath.random_fixedpoint(0fx,fmath.tau())
    pewpew.increase_score_of_player(0,25)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.play_sound("/dynamic/enemies/bosore/sound.lua",0,x,y)
    pewpew.new_mothership_bullet(x,y,1fx+ra,3fx,0xff3040ff,false)
    pewpew.new_mothership_bullet(x,y,3fx+ra,3fx,0x30ff40ff,false)
    pewpew.new_mothership_bullet(x,y,5fx+ra,3fx,0x3040ffff,false)
  end
  if data[2] == 0 then
    pewpew.customizable_entity_start_exploding(entity_id,35)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.play_sound("/dynamic/enemies/bosore/sound.lua",1,x,y)
    pewpew.new_floating_message(x,y,"#24ff2fff100",{scale = 1fx+1fx/4fx,ticks_before_fade = 10,is_optional = true})
  else
    data[2] = data[2]-1
  end
  return true
end
function bosore_new(x,y)
  local id = pewpew.new_customizable_entity(x,y)
 -- Format: {speed,life,angle,color_timer}
  bosores[id] = {0fx,5,0fx,0}
  pewpew.customizable_entity_set_mesh(id,"/dynamic/enemies/bosore/bosore_graphic.lua",0)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.entity_set_radius(id,11fx)
  pewpew.customizable_entity_set_visibility_radius(id,11fx)
  pewpew.customizable_entity_set_weapon_collision_callback(id,bosore_weapon_collision)
  pewpew.entity_set_update_callback(id,bosore_update)
  pewpew.customizable_entity_set_player_collision_callback(id,bosore_collide_with_ship)
end
local pindex = 0