local counter = pewpew.new_customizable_entity(0fx, 0fx)
pewpew.customizable_entity_set_mesh_scale(counter,4fx)
local time = 0
local count = 33
pewpew.add_update_callback(function()
  time = time + 1
  if time % 30 == 0 then
     count = count - 1
  end
  if pewpew.entity_get_is_alive(counter) then
    if count == 33 then
      pewpew.customizable_entity_set_string(counter, "#00000000" .. count)
    elseif count < 33 and count >= 24 then
      pewpew.customizable_entity_set_string(counter, "#ff0000ff" .. count)
    elseif count < 24 and count >= 16 then
      pewpew.customizable_entity_set_string(counter, "#ff0080ff" .. count)
    elseif count < 16 and count >= 8 then
      pewpew.customizable_entity_set_string(counter, "#ff8000ff" .. count)
    elseif count < 8 and count >= 0 then
      pewpew.customizable_entity_set_string(counter, "#ffff00ff" .. count)
    elseif count < 0 and count >= -1 then
      pewpew.customizable_entity_set_string(counter, "#00000000" .. count)
    end
  end
  if count == -1 then
    pewpew.entity_destroy(counter)
    pewpew.stop_game()
  end
end)