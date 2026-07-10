function level_particles(min_x,max_x,min_y,max_y,z,speed1,speed2,speed3,color1,color2,time,count)
  for i = 1,count do
    local rz = z
    local xx,yy,zz = speed1,speed2,speed3
    local rx,ry = fmath.random_fixedpoint(min_x,max_x),fmath.random_fixedpoint(min_y,max_y)
    pewpew.add_particle(rx,ry,rz,xx,yy,zz,color1,time)
    rx,ry = fmath.random_fixedpoint(min_x,max_x),fmath.random_fixedpoint(min_y,max_y)
    pewpew.add_particle(rx,ry,rz,xx,yy,zz,color2,time)
  end
end
-- Example: level_particles(-275fx,775fx,-275fx,775fx,50fx,fmath.random_fixedpoint(-2fx,2fx),fmath.random_fixedpoint(-2fx,2fx),fmath.random_fixedpoint(-2fx,2fx),0xffffffff,0xffffffff,57,2)