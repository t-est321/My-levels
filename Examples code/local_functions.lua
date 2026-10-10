local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end
local function random_speed()
  return fmath.random_fixedpoint(8fx,15fx)-- rs
end
local function rand_lev_part()
  return fmath.random_fixedpoint(-275fx,width+275fx),fmath.random_fixedpoint(-275fx,height+275fx)-- rx,ry
end