local w,h = 1300,1300
local cx,cy = w/2,h/2
local pi = 3.14159265
local tau = pi*2
local function fl(x)
  if x >= 0 then return x-x%1
  else return x-x%1-1 end
end
local function mn(a,b) if a < b then return a else return b end end
local function mx(a,b) if a > b then return a else return b end end
local function sin(x)
  x = x%(2*pi)
  if x > pi then x = x-2*pi end
  local x3 = x*x*x
  local x5 = x3*x*x
  local x7 = x5*x*x
  return x-x3/6+x5/120-x7/5040
end
local function cos(x) return sin(x+pi/2) end
local function rgba(r,g,b,a)
  r = fl(mn(255,mx(0,r)))
  g = fl(mn(255,mx(0,g)))
  b = fl(mn(255,mx(0,b)))
  a = fl(mn(255,mx(0,a)))
  return (r<<24)|(g<<16)|(b<<8)|a
end
local function lerp(a,b,t) return a+(b-a)*t end
local function add_l(m,x1,y1,z1,c1,x2,y2,z2,c2)
  local v = #m.vertexes
  m.vertexes[v+1] = {x1,y1,z1}
  m.vertexes[v+2] = {x2,y2,z2}
  m.colors[v+1] = c1
  m.colors[v+2] = c2
  m.segments[#m.segments+1] = {v,v+1}
end
local function prand(s)
  local v = sin(s*127.1+311.7)*43758.5453
  return v-fl(v)
end
local m1 = {vertexes={},segments={},colors={}}
local m2 = {vertexes={},segments={},colors={}}
local m3 = {vertexes={},segments={},colors={}}
local m4 = {vertexes={},segments={},colors={}}
local m5 = {vertexes={},segments={},colors={}}
local m6 = {vertexes={},segments={},colors={}}
local m7 = {vertexes={},segments={},colors={}}
local m8 = {vertexes={},segments={},colors={}}
local m9 = {vertexes={},segments={},colors={}}
local m10 = {vertexes={},segments={},colors={}}
meshes = {m1,m2,m3,m4,m5,m6,m7,m8,m9,m10}
for layer = 1,7 do
  local lz = -250-layer*80
  local lr = 280+layer*110
  local lox = sin(layer*1.8)*80
  local loy = cos(layer*2.3)*65
  local t = (layer-1)/6
  local nr = fl(lerp(200,60,t))
  local ng = fl(lerp(80,240,t))
  local nb = fl(lerp(240,255,t))
  local na = fl(lerp(120,50,t))
  for i = 1,24 do
    local a1 = (i/24)*tau
    local a2 = ((i+1)/24)*tau
    local wb1 = prand(layer*100+i*7.3)*90-45
    local wb2 = prand(layer*100+(i+1)*7.3)*90-45
    local r1 = lr+wb1
    local r2 = lr+wb2
    local x1 = cx+lox+cos(a1)*r1
    local y1 = cy+loy+sin(a1)*r1
    local x2 = cx+lox+cos(a2)*r2
    local y2 = cy+loy+sin(a2)*r2
    local zw1 = prand(layer*50+i*3.1)*70-35
    local zw2 = prand(layer*50+(i+1)*3.1)*70-35
    add_l(m1,x1,y1,lz+zw1,rgba(nr,ng,nb,na),x2,y2,lz+zw2,rgba(nr+30,ng+15,nb,na*0.8))
  end
  for i = 1,24,2 do
    local a1 = (i/24)*tau
    local wb1 = prand(layer*100+i*7.3)*90-45
    local rb = lr+wb1
    local xb = cx+lox+cos(a1)*rb
    local yb = cy+loy+sin(a1)*rb
    local ta = a1+prand(layer*200+i)*0.8-0.4
    local tl = 80+prand(layer*300+i)*140
    local xe = xb+cos(ta)*tl
    local ye = yb+sin(ta)*tl
    add_l(m1,xb,yb,lz,rgba(nr+50,ng+30,nb,na),xe,ye,lz-40,rgba(nr,ng,nb,10))
  end
end
for s = 1,10 do
  local ba = (s/10)*tau
  local sd = 1
  if s%2 == 0 then sd = -1 end
  local cs = prand(s*19.7)
  for i = 0,48 do
    local t1 = i/49
    local t2 = (i+1)/49
    local r1 = 620*(1-t1*t1)
    local r2 = 620*(1-t2*t2)
    local a1 = ba+t1*3.0*sd
    local a2 = ba+t2*3.0*sd
    local z1 = -t1*t1*800
    local z2 = -t2*t2*800
    local x1 = cx+cos(a1)*r1
    local y1 = cy+sin(a1)*r1
    local x2 = cx+cos(a2)*r2
    local y2 = cy+sin(a2)*r2
    local cr1 = fl(lerp(80+cs*50,255,t1))
    local cg1 = fl(lerp(210+cs*30,255,t1))
    local cb1 = fl(lerp(240,255,t1))
    local ca1 = fl(lerp(220,50,t1))
    local cr2 = fl(lerp(80+cs*50,255,t2))
    local cg2 = fl(lerp(210+cs*30,255,t2))
    local cb2 = fl(lerp(240,255,t2))
    local ca2 = fl(lerp(220,50,t2))
    add_l(m2,x1,y1,z1,rgba(cr1,cg1,cb1,ca1),x2,y2,z2,rgba(cr2,cg2,cb2,ca2))
  end
end
for r = 1,20 do
  local radius = 20+r*34
  local z = -r*45
  local t = (r-1)/19
  local rr = fl(lerp(255,40,t))
  local rg = fl(lerp(255,180,t))
  local rb = fl(lerp(255,230,t))
  local ra = fl(lerp(255,50,t))
  local da = 2+r*2
  local df = 3+r%5
  for i = 0,55 do
    local a1 = (i/56)*tau
    local a2 = ((i+1)/56)*tau
    local d1 = da*sin(a1*df+r*0.7)
    local d2 = da*sin(a2*df+r*0.7)
    local x1 = cx+cos(a1)*(radius+d1)
    local y1 = cy+sin(a1)*(radius+d1)
    local x2 = cx+cos(a2)*(radius+d2)
    local y2 = cy+sin(a2)*(radius+d2)
    local br = 0.7+0.3*sin(a1*3+r*1.3)
    local cv = fl(ra*br)
    add_l(m3,x1,y1,z,rgba(rr,rg,rb,cv),x2,y2,z,rgba(rr,rg,rb,cv))
  end
end
for i = 1,18 do
  local t = i/18
  local yp = cy+50+t*t*560
  local z = -t*600
  local sp = 200+t*540
  local al = fl(lerp(180,20,t))
  local gr = fl(lerp(120,30,t))
  local gg = fl(lerp(255,140,t))
  local gb = fl(lerp(255,200,t))
  add_l(m4,cx-sp,yp,z,rgba(gr,gg,gb,al*0.5),cx,yp,z,rgba(gr,gg,gb,al))
  add_l(m4,cx,yp,z,rgba(gr,gg,gb,al),cx+sp,yp,z,rgba(gr,gg,gb,al*0.5))
  local yp2 = cy-50-t*t*560
  add_l(m4,cx-sp,yp2,z,rgba(gr,gg*0.85,gb*0.9,al*0.4),cx,yp2,z,rgba(gr,gg*0.85,gb*0.9,al*0.85))
  add_l(m4,cx,yp2,z,rgba(gr,gg*0.85,gb*0.9,al*0.85),cx+sp,yp2,z,rgba(gr,gg*0.85,gb*0.9,al*0.4))
end
for i = 0,16 do
  local t = i/16
  local xn = cx+lerp(-200,200,t)
  local xf = cx+lerp(-740,740,t)
  add_l(m4,xn,cy+50,-15,rgba(100,240,255,160),xf,cy+610,-600,rgba(25,120,200,12))
  add_l(m4,xn,cy-50,-15,rgba(80,200,230,120),xf,cy-610,-600,rgba(20,100,180,10))
end
for i = 0,63 do
  local a = (i/64)*tau
  local dx,dy = cos(a),sin(a)
  local rt = i/64
  local rr = fl(lerp(100,160,sin(rt*tau*3)*0.5+0.5))
  local rg = fl(lerp(220,255,sin(rt*tau*5)*0.5+0.5))
  local rb = fl(lerp(230,255,cos(rt*tau*2)*0.5+0.5))
  add_l(m5,cx+dx*25,cy+dy*25,-350,rgba(rr,rg,rb,240),cx+dx*1700,cy+dy*1700,180,rgba(rr*0.5,rg*0.4,rb*0.6,0))
  if i%2 == 0 then
    local oa = a+0.02
    local odx,ody = cos(oa),sin(oa)
    add_l(m5,cx+odx*50,cy+ody*50,-370,rgba(rr,rg,rb,140),cx+odx*1300,cy+ody*1300,130,rgba(rr*0.3,rg*0.25,rb*0.4,0))
  end
end
for i = 1,100 do
  local r1 = prand(i*31.7+2.9)
  local r2 = prand(i*17.3+11.1)
  local r3 = prand(i*53.1+7.7)
  local r4 = prand(i*11.9+23.3)
  local r5 = prand(i*67.3+41.1)
  local angle = r1*tau
  local dist = 50+r2*540
  local sl = 8+r3*40
  local sx = cx+cos(angle)*dist
  local sy = cy+sin(angle)*dist
  local sz = -80-r4*400
  local fa = angle+r5*0.4-0.2
  local ex = sx+cos(fa)*sl
  local ey = sy+sin(fa)*sl
  local ez = sz+sl*0.5
  local st = fl(r5*4)
  local sr,sg,sb = 180,255,240
  if st == 1 then sr,sg,sb = 255,255,255
  elseif st == 2 then sr,sg,sb = 240,180,255
  elseif st == 3 then sr,sg,sb = 255,220,140 end
  local sa = mx(30,fl(250-dist*0.3))
  add_l(m6,sx,sy,sz,rgba(sr,sg,sb,sa),ex,ey,ez,rgba(sr*0.5,sg*0.5,sb*0.5,sa*0.2))
end
local cr_rays = 20
local cr_sz = 35
for i = 0,cr_rays-1 do
  local a = (i/cr_rays)*tau
  local dx,dy = cos(a),sin(a)
  add_l(m7,cx,cy,-520,rgba(255,255,255,255),cx+dx*cr_sz,cy+dy*cr_sz,-500,rgba(200,250,255,120))
  add_l(m7,cx+dx*2,cy+dy*2,-525,rgba(255,255,255,255),cx+dx*(cr_sz*0.6),cy+dy*(cr_sz*0.6),-510,rgba(255,255,255,200))
end
for p = 1,12 do
  local ba = (p/12)*tau
  for i = 0,15 do
    local t1 = i/16
    local t2 = (i+1)/16
    local l1 = t1*150
    local l2 = t2*150
    local pa1 = ba+sin(t1*pi)*0.35
    local pa2 = ba+sin(t2*pi)*0.35
    local x1 = cx+cos(pa1)*l1
    local y1 = cy+sin(pa1)*l1
    local x2 = cx+cos(pa2)*l2
    local y2 = cy+sin(pa2)*l2
    local z1 = -520+t1*60
    local z2 = -520+t2*60
    add_l(m7,x1,y1,z1,rgba(210,250,255,fl(lerp(220,20,t1))),x2,y2,z2,rgba(210,250,255,fl(lerp(220,20,t2))))
  end
end
for g = 1,6 do
  local gr = 10+g*14
  local gz = -520-g*16
  local ga = fl(lerp(255,50,g/6))
  for i = 0,39 do
    local a1 = (i/40)*tau
    local a2 = ((i+1)/40)*tau
    local x1 = cx+cos(a1)*gr
    local y1 = cy+sin(a1)*gr
    local x2 = cx+cos(a2)*gr
    local y2 = cy+sin(a2)*gr
    local pu = 0.6+0.4*sin(a1*5+g*2.3)
    add_l(m7,x1,y1,gz,rgba(220,252,255,fl(ga*pu)),x2,y2,gz,rgba(220,252,255,fl(ga*pu)))
  end
end
for i = 0,79 do
  local a1 = (i/80)*tau
  local a2 = ((i+1)/80)*tau
  local w1 = 12*sin(a1*7)
  local w2 = 12*sin(a2*7)
  local hr = 200
  local x1 = cx+cos(a1)*(hr+w1)
  local y1 = cy+sin(a1)*(hr+w1)
  local x2 = cx+cos(a2)*(hr+w2)
  local y2 = cy+sin(a2)*(hr+w2)
  local br = 0.5+0.5*sin(a1*4)
  add_l(m7,x1,y1,-200,rgba(130,220,255,fl(100*br)),x2,y2,-200,rgba(130,220,255,fl(100*br)))
end
local oh = 280
for i = 0,79 do
  local a1 = (i/80)*tau
  local a2 = ((i+1)/80)*tau
  local w1 = 18*sin(a1*5+1.2)
  local w2 = 18*sin(a2*5+1.2)
  local x1 = cx+cos(a1)*(oh+w1)
  local y1 = cy+sin(a1)*(oh+w1)
  local x2 = cx+cos(a2)*(oh+w2)
  local y2 = cy+sin(a2)*(oh+w2)
  local br = 0.5+0.5*sin(a1*3+2.0)
  add_l(m7,x1,y1,-170,rgba(100,200,240,fl(65*br)),x2,y2,-170,rgba(100,200,240,fl(65*br)))
end
for hex = 1,8 do
  local hr = 100+hex*70
  local hz = -150-hex*40
  local ht = (hex-1)/7
  local ha = fl(lerp(180,40,ht))
  local hcr = fl(lerp(180,60,ht))
  local hcg = fl(lerp(255,200,ht))
  local hcb = fl(lerp(255,240,ht))
  local rot = hex*0.13
  for i = 0,5 do
    local a1 = rot+(i/6)*tau
    local a2 = rot+((i+1)/6)*tau
    local x1 = cx+cos(a1)*hr
    local y1 = cy+sin(a1)*hr
    local x2 = cx+cos(a2)*hr
    local y2 = cy+sin(a2)*hr
    add_l(m8,x1,y1,hz,rgba(hcr,hcg,hcb,ha),x2,y2,hz,rgba(hcr,hcg,hcb,ha))
  end
  if hex > 1 then
    local pr = 100+(hex-1)*70
    local pz = -150-(hex-1)*40
    local prot = (hex-1)*0.13
    local pa = fl(lerp(180,40,(hex-2)/7))
    for i = 0,5 do
      local a1 = rot+(i/6)*tau
      local a2 = prot+(i/6)*tau
      local x1 = cx+cos(a1)*hr
      local y1 = cy+sin(a1)*hr
      local x2 = cx+cos(a2)*pr
      local y2 = cy+sin(a2)*pr
      add_l(m8,x1,y1,hz,rgba(hcr,hcg,hcb,ha*0.7),x2,y2,pz,rgba(hcr,hcg,hcb,pa*0.7))
    end
  end
end
for tri = 1,6 do
  local tr = 400+tri*50
  local tz = -100-tri*30
  local tt = (tri-1)/5
  local ta = fl(lerp(140,35,tt))
  local tcr = fl(lerp(140,50,tt))
  local tcg = fl(lerp(240,180,tt))
  local tcb = fl(lerp(255,220,tt))
  local trot = tri*0.25+0.5
  for i = 0,2 do
    local a1 = trot+(i/3)*tau
    local a2 = trot+((i+1)/3)*tau
    local x1 = cx+cos(a1)*tr
    local y1 = cy+sin(a1)*tr
    local x2 = cx+cos(a2)*tr
    local y2 = cy+sin(a2)*tr
    add_l(m9,x1,y1,tz,rgba(tcr,tcg,tcb,ta),x2,y2,tz,rgba(tcr,tcg,tcb,ta))
    local mx1 = cx+cos(a1)*tr*0.85
    local my1 = cy+sin(a1)*tr*0.85
    add_l(m9,x1,y1,tz,rgba(tcr,tcg,tcb,ta*0.5),mx1,my1,tz+20,rgba(tcr,tcg,tcb,ta*0.3))
  end
end
for d = 1,5 do
  local dr = 150+d*80
  local dz = -200-d*50
  local dt = (d-1)/4
  local da = fl(lerp(160,50,dt))
  local dcr = fl(lerp(220,80,dt))
  local dcg = fl(lerp(180,240,dt))
  local dcb = fl(lerp(255,255,dt))
  local drot = d*0.4
  for i = 0,3 do
    local a1 = drot+(i/4)*tau
    local a2 = drot+((i+1)/4)*tau
    local x1 = cx+cos(a1)*dr
    local y1 = cy+sin(a1)*dr
    local x2 = cx+cos(a2)*dr
    local y2 = cy+sin(a2)*dr
    add_l(m10,x1,y1,dz,rgba(dcr,dcg,dcb,da),x2,y2,dz,rgba(dcr,dcg,dcb,da))
  end
  local dr2 = dr*0.7
  local drot2 = drot+pi/4
  for i = 0,3 do
    local a1 = drot2+(i/4)*tau
    local a2 = drot2+((i+1)/4)*tau
    local x1 = cx+cos(a1)*dr2
    local y1 = cy+sin(a1)*dr2
    local x2 = cx+cos(a2)*dr2
    local y2 = cy+sin(a2)*dr2
    add_l(m10,x1,y1,dz-30,rgba(dcr,dcg,dcb,da*0.7),x2,y2,dz-30,rgba(dcr,dcg,dcb,da*0.7))
  end
  for i = 0,3 do
    local a1 = drot+(i/4)*tau
    local a2 = drot2+(i/4)*tau
    local x1 = cx+cos(a1)*dr
    local y1 = cy+sin(a1)*dr
    local x2 = cx+cos(a2)*dr2
    local y2 = cy+sin(a2)*dr2
    add_l(m10,x1,y1,dz,rgba(dcr,dcg,dcb,da*0.6),x2,y2,dz-30,rgba(dcr,dcg,dcb,da*0.5))
  end
end
for arc = 1,12 do
  local ar = 300+prand(arc*7.7)*300
  local aoff = prand(arc*13.1)*tau
  local alen = 0.3+prand(arc*23.3)*0.8
  local az = -100-prand(arc*31.7)*300
  local at = prand(arc*41.1)
  local acr = fl(lerp(100,200,at))
  local acg = fl(lerp(200,255,at))
  local acb = 255
  local aa = fl(lerp(160,60,prand(arc*51.3)))
  local segs = 10+fl(alen*15)
  for i = 0,segs-1 do
    local t1 = i/segs
    local t2 = (i+1)/segs
    local ang1 = aoff+t1*alen*tau
    local ang2 = aoff+t2*alen*tau
    local fade = sin(t1*pi)
    local fade2 = sin(t2*pi)
    local x1 = cx+cos(ang1)*ar
    local y1 = cy+sin(ang1)*ar
    local x2 = cx+cos(ang2)*ar
    local y2 = cy+sin(ang2)*ar
    add_l(m9,x1,y1,az,rgba(acr,acg,acb,aa*fade),x2,y2,az,rgba(acr,acg,acb,aa*fade2))
  end
end