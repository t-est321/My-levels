local EskivBox = {}
function EskivBox.spawn(x,y)
  local value = 600
  local box = pewpew.new_customizable_entity(x,y)
  pewpew.customizable_entity_set_mesh(box,"/dynamic/Eskiv_box_mesh.lua",0)
  pewpew.entity_set_radius(box,22fx)
  pewpew.customizable_entity_set_mesh_scale(box,fmath.from_fraction(3,4))
  pewpew.customizable_entity_start_spawning(box,30)
  pewpew.create_explosion(x,y,0x00ffffff,1fx,25)
  pewpew.customizable_entity_set_player_collision_callback(box,function(id,player)
    pewpew.increase_score_of_player(0,value)
    pewpew.create_explosion(x,y,0x00ffffff,1fx,40)
    pewpew.entity_destroy(id)
  end)
  pewpew.entity_set_update_callback(box,function(id)
    if value > 0 then
      value = value-1
    end
    pewpew.customizable_entity_add_rotation_to_mesh(id,fmath.from_fraction(1,45),1fx,0fx,0fx)
    pewpew.customizable_entity_add_rotation_to_mesh(id,fmath.from_fraction(1,60),0fx,1fx,0fx)
    pewpew.customizable_entity_set_string(id,tostring(value))
    if value < 120 then
      if tick%10 < 5 then
        pewpew.customizable_entity_set_mesh_color(id,0xff0000ff)
      else
        pewpew.customizable_entity_set_mesh_color(id,0xffffffff)
      end
    end
    if value <= 0 then
      pewpew.create_explosion(x,y,0xff0000ff,1fx,30)
      pewpew.entity_destroy(id)
    end
  end)
  return box
end
return EskivBox