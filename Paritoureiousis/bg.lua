require("/dynamic/bgHelper.lua")
meshes = {{vertexes={},segments={},colors={}}}
local w = 1500
local h = 1500
local q = 100
local startColor = 0x52b4ffff
local endColor = 0x51d9baff
local minX = -600
local minY = -300
local minZ = -35
local maxX = w+600
local maxY = h+300
local maxZ = 100
local rangeZ = maxZ-minZ
local gap = 100
local m = meshes[1]
for z = minZ,maxZ,q do
  local p = (z-minZ)/rangeZ
  local color = InterpolateColor(startColor,endColor,p)
  for x = minX,maxX,q do
    if x <= -gap or x >= w+gap then
      AddLineToMesh(m,{{x,minY,z},{x,maxY,z}},{color,color})
    else
      AddLineToMesh(m,{{x,minY,z},{x,-gap,z}},{color,color})
      AddLineToMesh(m,{{x,h+gap,z},{x,maxY,z}},{color,color})
    end
  end
  for y = minY,maxY,q do
    if y <= -gap or y >= h+gap then
      AddLineToMesh(m,{{minX,y,z},{maxX,y,z}},{color,color})
    else
      AddLineToMesh(m,{{minX,y,z},{-gap,y,z}},{color,color})
      AddLineToMesh(m,{{w+gap,y,z},{maxX,y,z}},{color,color})
    end
  end
end