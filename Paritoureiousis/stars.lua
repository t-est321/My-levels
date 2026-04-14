local ins,rnd=table.insert,math.random
local v,s,c={},{},{}
local idx=0
for i=0,3750 do
  local x,y,z=rnd(-1850,1850),rnd(-1850,1850),rnd(-2450,-150)
  ins(v,{x-0.2,y-0.2,z})ins(v,{x-0.2,y+0.2,z})
  ins(s,{idx,idx+1})
  ins(c,0xffffffff)ins(c,0xffffffff)
  idx=idx+2
end
meshes={{vertexes=v,segments=s,colors=c}}
-- 7500 line