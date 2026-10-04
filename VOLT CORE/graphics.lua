meshes = {}

local function polygon_vertexes(cx,cy,radius,sides,rotation)
  local vertexes = {}
  for i = 0,sides-1 do
    local a = rotation+i*2*math.pi/sides
    vertexes[i+1] = {cx+radius*math.cos(a),cy+radius*math.sin(a),0}
  end
  return vertexes
end

local function add_polygon(mesh,cx,cy,radius,sides,rotation,color)
  local base = #mesh.vertexes
  local vertexes = polygon_vertexes(cx,cy,radius,sides,rotation)
  for i = 0,sides-1 do
    mesh.vertexes[base+i+1] = vertexes[i+1]
    mesh.colors[base+i+1] = color
  end
  local chain = {}
  for j = 0,sides do
    chain[j+1] = j%sides+base
  end
  mesh.segments[#mesh.segments+1] = chain
end

local function add_line(mesh,x1,y1,x2,y2,color)
  local base = #mesh.vertexes
  mesh.vertexes[base+1] = {x1,y1,0}
  mesh.vertexes[base+2] = {x2,y2,0}
  mesh.colors[base+1] = color
  mesh.colors[base+2] = color
  mesh.segments[#mesh.segments+1] = {base,base+1}
end

local background = {vertexes = {},colors = {},segments = {}}
for x = 0,700,50 do
  add_line(background,x,0,x,500,0x1a3a5c60)
end
for y = 0,500,50 do
  add_line(background,0,y,700,y,0x1a3a5c60)
end
do
  local base = #background.vertexes
  background.vertexes[base+1] = {3,3,0}
  background.vertexes[base+2] = {697,3,0}
  background.vertexes[base+3] = {697,497,0}
  background.vertexes[base+4] = {3,497,0}
  local border_color = 0x4080c0ff
  background.colors[base+1] = border_color
  background.colors[base+2] = border_color
  background.colors[base+3] = border_color
  background.colors[base+4] = border_color
  background.segments[#background.segments+1] = {base,base+1,base+2,base+3,base}
end
meshes[1] = background

local boss = {vertexes = {},colors = {},segments = {}}
add_polygon(boss,0,0,15,6,0,0x00e5ffff)
add_polygon(boss,0,0,9.5,6,math.pi/6,0xb040ffff)
add_polygon(boss,0,0,5,3,math.pi/2,0xffffffff)
for i = 0,5 do
  local a = i*math.pi/3
  add_line(boss,15*math.cos(a),15*math.sin(a),22*math.cos(a),22*math.sin(a),0x00e5ffcc)
end
add_polygon(boss,0,0,1.2,4,math.pi/4,0xffffffff)
meshes[2] = boss

local orb = {vertexes = {},colors = {},segments = {}}
add_polygon(orb,0,0,7,8,math.pi/8,0xffe000ff)
add_polygon(orb,0,0,2,4,math.pi/4,0xffffffff)
meshes[3] = orb

local ring = {vertexes = {},colors = {},segments = {}}
add_polygon(ring,0,0,10,32,0,0xff3030b0)
meshes[4] = ring
