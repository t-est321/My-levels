require("/dynamic/bgHelper.lua")
meshes = {{vertexes={},segments={},colors={}}}
local w = 1300
local h = 1300
local minX = -600
local minY = -300
local minZ = -35
local maxX = w+600
local maxY = h+300
local maxZ = 100
local gap = 100
local m = meshes[1]
local accentColor = 0x8a5cffcc
local accentColor2 = 0x35ff75cc
local fc = 0x51d9bacc
local fo = 50
AddLineToMesh(m,{{-fo,-fo,maxZ},{w+fo,-fo,maxZ}},{fc,fc})
AddLineToMesh(m,{{w+fo,-fo,maxZ},{w+fo,h+fo,maxZ}},{fc,fc})
AddLineToMesh(m,{{w+fo,h+fo,maxZ},{-fo,h+fo,maxZ}},{fc,fc})
AddLineToMesh(m,{{-fo,h+fo,maxZ},{-fo,-fo,maxZ}},{fc,fc})
local fc2 = 0x52b4ff99
local fo2 = 130
AddLineToMesh(m,{{-fo2,-fo2,minZ},{w+fo2,-fo2,minZ}},{fc2,fc2})
AddLineToMesh(m,{{w+fo2,-fo2,minZ},{w+fo2,h+fo2,minZ}},{fc2,fc2})
AddLineToMesh(m,{{w+fo2,h+fo2,minZ},{-fo2,h+fo2,minZ}},{fc2,fc2})
AddLineToMesh(m,{{-fo2,h+fo2,minZ},{-fo2,-fo2,minZ}},{fc2,fc2})
AddLineToMesh(m,{{-fo,-fo,maxZ},{-fo2,-fo2,minZ}},{fc,fc2})
AddLineToMesh(m,{{w+fo,-fo,maxZ},{w+fo2,-fo2,minZ}},{fc,fc2})
AddLineToMesh(m,{{w+fo,h+fo,maxZ},{w+fo2,h+fo2,minZ}},{fc,fc2})
AddLineToMesh(m,{{-fo,h+fo,maxZ},{-fo2,h+fo2,minZ}},{fc,fc2})
for i = 0,14 do
  local p = i/14
  local gcol = InterpolateColor(accentColor,accentColor2,p)
  local px = p*w
  local py = p*h
  AddLineToMesh(m,{{px,0,maxZ},{px,-85,maxZ}},{gcol,gcol})
  AddLineToMesh(m,{{px,h,maxZ},{px,h+85,maxZ}},{gcol,gcol})
  AddLineToMesh(m,{{0,py,maxZ},{-85,py,maxZ}},{gcol,gcol})
  AddLineToMesh(m,{{w,py,maxZ},{w+85,py,maxZ}},{gcol,gcol})
end
for i = 0,14 do
  local p = i/14
  local gcol2 = InterpolateColor(0x52b4ffff,accentColor,p)
  local px = p*w
  local py = p*h
  AddLineToMesh(m,{{px,0,minZ},{px,-60,minZ}},{gcol2,gcol2})
  AddLineToMesh(m,{{px,h,minZ},{px,h+60,minZ}},{gcol2,gcol2})
  AddLineToMesh(m,{{0,py,minZ},{-60,py,minZ}},{gcol2,gcol2})
  AddLineToMesh(m,{{w,py,minZ},{w+60,py,minZ}},{gcol2,gcol2})
end
local midZ = (minZ+maxZ)/2
local innerFrame = 0x51d9ba88
local ifs = 25
AddLineToMesh(m,{{-ifs,-ifs,midZ},{w+ifs,-ifs,midZ}},{innerFrame,innerFrame})
AddLineToMesh(m,{{w+ifs,-ifs,midZ},{w+ifs,h+ifs,midZ}},{innerFrame,innerFrame})
AddLineToMesh(m,{{w+ifs,h+ifs,midZ},{-ifs,h+ifs,midZ}},{innerFrame,innerFrame})
AddLineToMesh(m,{{-ifs,h+ifs,midZ},{-ifs,-ifs,midZ}},{innerFrame,innerFrame})
local crossColor = 0x35ff7566
AddLineToMesh(m,{{w/2,minY,minZ},{w/2,-gap,minZ}},{crossColor,crossColor})
AddLineToMesh(m,{{w/2,h+gap,minZ},{w/2,maxY,minZ}},{crossColor,crossColor})
AddLineToMesh(m,{{minX,h/2,minZ},{-gap,h/2,minZ}},{crossColor,crossColor})
AddLineToMesh(m,{{w+gap,h/2,minZ},{maxX,h/2,minZ}},{crossColor,crossColor})
AddLineToMesh(m,{{w/2,minY,maxZ},{w/2,-gap,maxZ}},{crossColor,crossColor})
AddLineToMesh(m,{{w/2,h+gap,maxZ},{w/2,maxY,maxZ}},{crossColor,crossColor})
AddLineToMesh(m,{{minX,h/2,maxZ},{-gap,h/2,maxZ}},{crossColor,crossColor})
AddLineToMesh(m,{{w+gap,h/2,maxZ},{maxX,h/2,maxZ}},{crossColor,crossColor})