meshes = {}

local TAU = math.pi*2

local function mesh()
  local m = {vertexes = {},segments = {}}
  meshes[#meshes+1] = m
  return m
end

local function chain(m,points,closed)
  local base = #m.vertexes
  for i = 1,#points do
    local point = points[i]
    if point[3] == nil or point[3] == 0 then
      m.vertexes[#m.vertexes+1] = {point[1],point[2]}
    else
      m.vertexes[#m.vertexes+1] = {point[1],point[2],point[3]}
    end
  end
  local c = {}
  for i = 1,#points do
    c[i] = base+i-1
  end
  if closed then
    c[#c+1] = base
  end
  m.segments[#m.segments+1] = c
end

local function box(m,x,y,w,h)
  local hw = w/2
  local hh = h/2
  chain(m,{{x-hw,y-hh},{x+hw,y-hh},{x+hw,y+hh},{x-hw,y+hh}},true)
end

local function filled_box(m,x,y,w,h,inset)
  box(m,x,y,w,h)
  box(m,x,y,w-inset,h-inset)
end

local function line(m,x1,y1,x2,y2)
  chain(m,{{x1,y1},{x2,y2}},false)
end

local function polygon(m,cx,cy,radius,sides,rotation)
  local points = {}
  for i = 0,sides-1 do
    local angle = rotation+i*(TAU/sides)
    points[#points+1] = {cx+math.cos(angle)*radius,cy+math.sin(angle)*radius}
  end
  chain(m,points,true)
end

local function circle(m,cx,cy,radius)
  polygon(m,cx,cy,radius,14,0)
end

local function star(m,cx,cy,outer,inner,points,rotation)
  local list = {}
  for i = 0,points*2-1 do
    local angle = rotation+i*(TAU/(points*2))
    local radius = inner
    if i%2 == 0 then
      radius = outer
    end
    list[#list+1] = {cx+math.cos(angle)*radius,cy+math.sin(angle)*radius}
  end
  chain(m,list,true)
end

local function chevron(m,x,y,w,h)
  line(m,x-w,y+h,x,y)
  line(m,x,y,x-w,y-h)
end

local m

m = mesh()
filled_box(m,0,0,24,26,4)
line(m,-8,0,8,0)

m = mesh()
filled_box(m,0,0,24,26,4)
line(m,-8,-5,8,-5)
line(m,-8,0,8,0)
line(m,-8,5,8,5)

m = mesh()
filled_box(m,0,0,24,26,4)
line(m,-9,-6,9,6)
line(m,-9,6,9,-6)

m = mesh()
filled_box(m,0,0,28,22,5)
line(m,-8,0,8,0)
line(m,-14,-11,-14,-16)
line(m,14,-11,14,-16)
line(m,-14,11,-14,16)
line(m,14,11,14,16)

m = mesh()
polygon(m,0,0,16,6,TAU/12)
chevron(m,-1,0,6,7)
chevron(m,9,0,6,7)

m = mesh()
polygon(m,0,0,18,6,TAU/12)
chevron(m,-5,0,5,7)
chevron(m,3,0,5,7)
chevron(m,11,0,5,7)

m = mesh()
polygon(m,0,0,18,3,TAU/4)
line(m,0,6,0,-2)
line(m,0,-6,0,-8)

m = mesh()
star(m,0,0,19,9,8,TAU/16)
line(m,-6,-6,6,6)
line(m,-6,6,6,-6)

m = mesh()
polygon(m,0,0,17,8,TAU/16)
box(m,0,0,19,5)

m = mesh()
box(m,0,0,25,25)
box(m,0,0,17,17)
line(m,-8,8,8,-8)

m = mesh()
star(m,0,0,20,10,6,TAU/12)
polygon(m,0,0,7,6,0)
line(m,0,-7,0,-14)
line(m,-3,-14,3,-14)

m = mesh()
for i = 0,5 do
  local a = TAU/12+i*(TAU/6)
  line(m,math.cos(a-3/10)*17,math.sin(a-3/10)*17,math.cos(a+3/10)*17,math.sin(a+3/10)*17)
end
line(m,-5,5,-1,8)
line(m,-1,8,4,5)
line(m,4,5,0,1)
line(m,0,-3,0,-6)

m = mesh()
filled_box(m,0,0,500,46,6)
box(m,0,0,486,34)
line(m,-244,20,-232,20)
line(m,232,20,244,20)
line(m,-244,-20,-232,-20)
line(m,232,-20,244,-20)
line(m,-250,-23,-250,23)
line(m,250,-23,250,23)

m = mesh()
box(m,7,-7,140,96)
filled_box(m,0,0,140,96,6)
line(m,-70,32,70,32)
filled_box(m,58,32,16,16,4)
line(m,53,37,63,27)
line(m,53,27,63,37)
line(m,-60,18,34,18)
line(m,-60,6,54,6)
line(m,-60,-6,22,-6)
line(m,-60,-18,46,-18)
line(m,-60,-30,30,-30)
line(m,64,28,64,-40)

m = mesh()
filled_box(m,0,0,120,64,6)
line(m,-60,20,60,20)
line(m,-48,4,48,4)
line(m,-48,-10,20,-10)

m = mesh()
polygon(m,0,0,17,3,TAU/4)
line(m,0,5,0,-3)
line(m,0,-7,0,-9)

m = mesh()
polygon(m,0,0,10,4,0)
line(m,-5,0,5,0)
line(m,0,-5,0,5)

m = mesh()
line(m,-90,0,90,0)
line(m,-90,5,90,5)
line(m,-90,-5,90,-5)

m = mesh()
polygon(m,0,0,34,8,TAU/16)
polygon(m,0,0,26,8,TAU/16)
line(m,-22,26,-14,38)
line(m,14,38,22,26)
line(m,-8,10,8,-2)
line(m,-20,-14,20,-14)
line(m,-14,22,14,22)

m = mesh()
polygon(m,0,0,92,12,0)
polygon(m,0,0,74,12,TAU/24)
for i = 0,11 do
  local a = i*(TAU/12)
  line(m,math.cos(a)*92,math.sin(a)*92,math.cos(a)*101,math.sin(a)*101)
end

m = mesh()
polygon(m,0,0,44,6,TAU/12)
polygon(m,0,0,30,6,TAU/12)
polygon(m,0,0,16,6,TAU/12)
line(m,-6,0,6,0)
line(m,0,-6,0,6)

m = mesh()
circle(m,-2,2,9)
line(m,5,-5,12,-12)
line(m,-2,-3,-2,7)
line(m,-7,2,3,2)

m = mesh()
chain(m,{{0,14},{12,8},{12,-3},{0,-14},{-12,-3},{-12,8}},true)
line(m,-12,3,12,3)
line(m,-10,-5,10,-5)
line(m,-4,14,-4,3)
line(m,5,3,5,-5)
line(m,-3,-5,-3,-12)

m = mesh()
box(m,-7,7,11,11)
box(m,6,7,11,11)
box(m,-7,-6,11,11)
box(m,7,-7,9,9)
line(m,2,-2,10,-2)
line(m,10,-2,7,-5)

m = mesh()
circle(m,0,0,13)
line(m,0,0,0,8)
line(m,0,0,6,-3)
line(m,0,13,0,16)

m = mesh()
chain(m,{{0,-13},{-8,-5},{-12,2},{-9,9},{-3,11},{0,6},{3,11},{9,9},{12,2},{8,-5}},true)

m = mesh()
box(m,0,0,28,22)
box(m,0,0,22,16)
line(m,-14,11,-2,11)
line(m,-2,11,-2,14)

m = mesh()
filled_box(m,0,0,1000,44,4)
line(m,22,22,22,-22)
box(m,-470,0,34,30)
line(m,-300,21,300,21)
for i = 1,6 do
  local x = 90+i*40
  box(m,x,0,22,22)
end
box(m,430,0,30,26)
box(m,468,0,30,26)

m = mesh()
filled_box(m,0,0,560,70,10)
line(m,270,26,270,-26)
line(m,-270,26,-270,-26)
line(m,-244,-22,244,-22)
for i = 1,9 do
  local x = -244+i*50
  box(m,x,-22,6,6)
end

m = mesh()
star(m,0,0,26,10,12,0)
polygon(m,0,0,8,6,0)

m = mesh()
for i = 1,6 do
  local angle = i*(TAU/6)
  local r1 = 8+i*3
  local r2 = r1+14
  line(m,math.cos(angle)*r1,math.sin(angle)*r1,math.cos(angle)*r2,math.sin(angle)*r2)
end

m = mesh()
chain(m,{{12,0},{-6,9},{-6,4},{-13,4},{-13,-4},{-6,-4},{-6,-9}},true)

m = mesh()
chain(m,{{-500,-350},{500,-350},{500,350},{-500,350}},true)

m = mesh()
chain(m,{{-500,350},{500,350},{500,150},{-500,150}},true)

m = mesh()
for i = 0,87 do
  local y = -350+i*8
  line(m,-500,y,500,y)
end

m = mesh()
for i = 0,5 do
  local x = -500+i*200
  line(m,x,-350,x,350)
end
for i = 0,10 do
  local x = -500+i*100
  line(m,x,-350,x,350)
end
for i = 0,3 do
  local y = -350+i*200
  line(m,-500,y,500,y)
end
for i = 0,6 do
  local y = -350+i*100
  line(m,-500,y,500,y)
end
line(m,-500,350,-440,350)
line(m,-500,350,-500,290)
line(m,500,-350,440,-350)
line(m,500,-350,500,-290)
line(m,-500,-120,-400,-220)
line(m,500,-40,410,-130)

m = mesh()
box(m,-330,120,240,150)
line(m,-450,195,-210,195)
line(m,-440,170,-330,170)
line(m,-440,150,-300,150)
line(m,-440,130,-350,130)
box(m,300,180,260,170)
line(m,170,265,430,265)
line(m,180,240,330,240)
line(m,180,220,390,220)
box(m,120,-170,180,120)
line(m,30,-110,210,-110)
line(m,40,-135,150,-135)

m = mesh()
filled_box(m,0,0,20,20,6)
line(m,-4,-6,-4,6)
line(m,0,-6,0,6)
line(m,4,-6,4,6)

m = mesh()
box(m,0,0,20,20)

m = mesh()
filled_box(m,0,0,20,20,6)
line(m,-6,-6,6,6)
line(m,-6,6,6,-6)
line(m,-10,0,-6,0)
line(m,6,0,10,0)

m = mesh()
chain(m,{{-500,-60},{500,-60},{500,60},{-500,60}},true)
line(m,-500,60,500,60)
