require("/dynamic/helpers/fury_gfx_helpers.lua")
meshes = {{vertexes = {},segments = {},colors = {}}}

local w = 500
local h = 500
local q = 50
local color = 0xffffff30
local bgcolor = 0xff2323a0

local minX = -300
local minY = -150
local minZ = -50
local maxX = w+300
local maxY = h+150
local maxZ = 150

for z = minZ,maxZ,q do
  local percentage = (z-minZ)/(maxZ-minZ)
  for x = minX,maxX,q do
    if x <= 0 or x >= w then
      AddLineToMesh(meshes[1],{{x,minY,z},{x,maxY,z}},{color,color})
    else
      AddLineToMesh(meshes[1],{{x,minY,z},{x,0,z}},{color,color})
      AddLineToMesh(meshes[1],{{x,h,z},{x,maxY,z}},{color,color})
      if z == 0 then
        AddLineToMesh(meshes[1],{{x,0,z},{x,h,z}},{bgcolor,bgcolor})
      end
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