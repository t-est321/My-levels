require("/dynamic/bgHelper.lua")
meshes = {{vertexes={},segments={},colors={}}}
local w = 1300
local h = 1300
local minX = -600
local minY = -300
local maxX = w+600
local maxY = h+300
local minZ = -35
local maxZ = 100
local c1 = 0x52b4ffbb
local c2 = 0x51d9babb
local ca = 0x8a5cff88
local sp = 200
local mg = 250
local s = 30
local m = meshes[1]
for x = minX,maxX,sp do
  for y = minY,maxY,sp do
    local ox = x <= -mg or x >= w+mg
    local oy = y <= -mg or y >= h+mg
    if ox or oy then
      AddLineToMesh(m,{{x-s,y-s,minZ},{x+s,y-s,minZ}},{ca,ca})
      AddLineToMesh(m,{{x+s,y-s,minZ},{x+s,y+s,minZ}},{ca,ca})
      AddLineToMesh(m,{{x+s,y+s,minZ},{x-s,y+s,minZ}},{ca,ca})
      AddLineToMesh(m,{{x-s,y+s,minZ},{x-s,y-s,minZ}},{ca,ca})
      AddLineToMesh(m,{{x-s,y-s,maxZ},{x+s,y-s,maxZ}},{c2,c2})
      AddLineToMesh(m,{{x+s,y-s,maxZ},{x+s,y+s,maxZ}},{c2,c2})
      AddLineToMesh(m,{{x+s,y+s,maxZ},{x-s,y+s,maxZ}},{c2,c2})
      AddLineToMesh(m,{{x-s,y+s,maxZ},{x-s,y-s,maxZ}},{c2,c2})
      AddLineToMesh(m,{{x-s,y-s,minZ},{x-s,y-s,maxZ}},{c1,c2})
      AddLineToMesh(m,{{x+s,y-s,minZ},{x+s,y-s,maxZ}},{c1,c2})
      AddLineToMesh(m,{{x+s,y+s,minZ},{x+s,y+s,maxZ}},{c1,c2})
      AddLineToMesh(m,{{x-s,y+s,minZ},{x-s,y+s,maxZ}},{c1,c2})
    end
  end
end