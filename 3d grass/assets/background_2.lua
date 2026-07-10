require("/dynamic/helpers/gfx.lua")
meshes = {{vertexes = {},segments = {},colors = {}}}

local w = 1200
local h = 1200
local q = 50
local startColor = 0x00ff0023
local endColor = 0x00ff00a0

local minX = -50
local minY = -50
local minZ = 0
local maxX = w+50
local maxY = h+50
local maxZ = 50

for z = minZ,maxZ,q do
  local percentage = (z-minZ)/(maxZ-minZ)
  local color = InterpolateColor(startColor,endColor,percentage)
  for x = minX,maxX,q do
    if x <= 0 or x >= w then
      AddLineToMesh(meshes[1],{{x,minY,z},{x,maxY,z}},{color,color})
    else
      AddLineToMesh(meshes[1],{{x,minY,z},{x,0,z}},{color,color})
      AddLineToMesh(meshes[1],{{x,h,z},{x,maxY,z}},{color,color})
    end
  end
  for y = minY,maxY,q do
    if y <= 0 or y >= h then
      AddLineToMesh(meshes[1],{{minX,y,z},{maxX,y,z}},{color,color})
    else
      AddLineToMesh(meshes[1],{{minX,y,z},{0,y,z}},{color,color})
      AddLineToMesh(meshes[1],{{w,y,z},{maxX,y,z}},{color,color})
    end
  end
end
for x = minX,maxX,q do
  for y = minY,maxY,q do
    if x <= 0 or x >= w or y <= 0 or y >= h then
      AddLineToMesh(meshes[1],{{x,y,minZ},{x,y,maxZ}},{startColor,endColor})
    end
  end
end