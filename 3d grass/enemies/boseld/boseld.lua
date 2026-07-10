--boss+shield
local boselds = {}
function boseld_update(entity_id)
  local data = boselds[entity_id]
  local x,y = pewpew.entity_get_position(entity_id)
  pewpew.customizable_entity_set_mesh_angle(entity_id,data[3],0fx,0fx,1fx)
  data[3] = data[3]+0.1000fx

  if data == nil then return true end
  if data[4] > 0 then
    data[4] = data[4] - 1
    if data[4] == 0 then
      pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/enemies/boseld/boseld_graphic.lua",0)
    end
  end

  pewpew.entity_set_position(entity_id,x,y)
  if pewpew.entity_get_is_started_to_be_destroyed(entity_id) == true then
    boselds[entity_id] = nil
    pewpew.customizable_entity_set_player_collision_callback(entity_id,nil)
    pewpew.customizable_entity_set_weapon_collision_callback(entity_id,nil)
    pewpew.entity_set_update_callback(entity_id,nil)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.increase_score_of_player(0,350)
    pewpew.print("boseld: + 350 score")
    local ra = fmath.random_fixedpoint(0fx,fmath.tau())
    pewpew.new_mothership_bullet(x,y,1fx+ra,3fx,0xff3040ff,false)
    pewpew.new_mothership_bullet(x,y,2fx+ra,3fx,0xffff40ff,false)
    pewpew.new_mothership_bullet(x,y,3fx+ra,3fx,0x30ff40ff,false)
    pewpew.new_mothership_bullet(x,y,4fx+ra,3fx,0x30ffffff,false)
    pewpew.new_mothership_bullet(x,y,5fx+ra,3fx,0x3040ffff,false)
    pewpew.new_mothership_bullet(x,y,6fx+ra,3fx,0xff40ffff,false)
    pewpew.new_pointonium(x,y,64)
  end
end
function boseld_collide_with_ship(entity_id,pindex,ship_entity_id)
  pewpew.customizable_entity_start_exploding(entity_id,50)
  local x,y = pewpew.entity_get_position(entity_id)
  pewpew.play_sound("/dynamic/enemies/boseld/sound.lua",1,x,y)
  pewpew.new_floating_message(x,y,"#24ff2fff350",{scale = 1fx+1fx/4fx,ticks_before_fade = 20,is_optional = true})
  pewpew.add_damage_to_player_ship(ship_entity_id,1)
end
function boseld_weapon_collision(entity_id,weapon_description)
  local data = boselds[entity_id]

  if data == nil then return true end
  pewpew.customizable_entity_set_mesh(entity_id,"/dynamic/enemies/boseld/boseld_graphic_white.lua",0)
  data[4] = 2

  if data[2] >= 0 then
    local ra = fmath.random_fixedpoint(0fx,fmath.tau())
    pewpew.increase_score_of_player(0,15)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.play_sound("/dynamic/enemies/boseld/sound.lua",0,x,y)
    pewpew.new_mothership_bullet(x,y,1fx+ra,3fx,0xff3040ff,false)
    pewpew.new_mothership_bullet(x,y,3fx+ra,3fx,0x30ff40ff,false)
    pewpew.new_mothership_bullet(x,y,5fx+ra,3fx,0x3040ffff,false)
  end
  if data[2] == 0 then
    pewpew.customizable_entity_start_exploding(entity_id,35)
    local x,y = pewpew.entity_get_position(entity_id)
    pewpew.play_sound("/dynamic/enemies/boseld/sound.lua",1,x,y)
    pewpew.new_floating_message(x,y,"#24ff2fff350",{scale = 1fx+1fx/4fx,ticks_before_fade = 10,is_optional = true})
  else
    data[2] = data[2]-1
  end
  return true
end
function boseld_new(x,y)
  local id = pewpew.new_customizable_entity(x,y)
 -- Format: {speed,life,angle,color_timer}
  boselds[id] = {0fx,25,0fx,0}
  pewpew.customizable_entity_set_mesh(id,"/dynamic/enemies/boseld/boseld_graphic.lua",0)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.entity_set_radius(id,20fx)
  pewpew.customizable_entity_set_visibility_radius(id,25fx)
  pewpew.customizable_entity_set_weapon_collision_callback(id,boseld_weapon_collision)
  pewpew.entity_set_update_callback(id,boseld_update)
  pewpew.customizable_entity_set_player_collision_callback(id,boseld_collide_with_ship)
end
local pindex = 0