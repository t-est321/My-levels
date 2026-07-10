function add_ufo(x,y,speed,collision)
  if collision == false then
    pewpew.new_ufo(x,y,speed)
  end
  if collision == true then
    local ufo = pewpew.new_ufo(x,y,speed)
    pewpew.ufo_set_enable_collisions_with_walls(ufo,true)
  end
end
-- Example: add_ufo(500fx,500fx,3fx,true)