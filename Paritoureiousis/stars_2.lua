local ins,rnd=table.insert,math.random
local v,s,c={},{},{}
local idx=0
for i=0,1250 do
  local x,y,z=rnd(-1450,1450),rnd(-1450,1450),rnd(10,250)
  ins(v,{x-0.1,y-0.1,z})ins(v,{x-0.1,y+0.1,z})
  ins(s,{idx,idx+1})
  ins(c,0xffffffcc)ins(c,0xffffffcc)
  idx=idx+2
end
for i=0,1000 do
  local x,y,z=rnd(-1450,1450),rnd(-1450,1450),rnd(10,250)
  ins(v,{x-0.2,y-0.2,z})ins(v,{x-0.2,y+0.2,z})
  ins(s,{idx,idx+1})
  ins(c,0x9900ffcc)ins(c,0x9900ffcc)
  idx=idx+2
end
for i=0,1000 do
  local x,y,z=rnd(-1450,1450),rnd(-1450,1450),rnd(10,250)
  ins(v,{x-0.2,y-0.2,z})ins(v,{x-0.2,y+0.2,z})
  ins(s,{idx,idx+1})
  ins(c,0x0099ffcc)ins(c,0x0099ffcc)
  idx=idx+2
end
meshes={{vertexes=v,segments=s,colors=c}}
-- 6500 line