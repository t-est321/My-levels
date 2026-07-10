function shield_spawn(x,y,particle_time,particle_color,shield_count,shield_time)
  for count = 1,25 do
    local speed_x,speed_y = fmath.random_fixedpoint(-6fx,6fx),fmath.random_fixedpoint(-6fx,6fx)
    pewpew.add_particle(x,y,0fx,speed_x,speed_y,20fx,particle_color,particle_time)
  end
  for count = 1,12 do
    local speed_x,speed_y = fmath.random_fixedpoint(-6fx,6fx),fmath.random_fixedpoint(-6fx,6fx)
    pewpew.add_particle(x,y,0fx,speed_x,speed_y,-6fx,particle_color,particle_time)
  end
  pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = shield_count,box_duration = shield_time})
end
-- Example: shield_spawn(500fx,500fx,25,0xffff00ee,1,215)