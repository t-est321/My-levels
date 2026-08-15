require("/dynamic/helpers/fury_gfx_helpers.lua")
meshes = {{vertexes = {},segments = {},colors = {}}}

local w = 500
local h = 500
local q = 50
local startColor = 0xffffff30
local endColor = 0xffffff90

local minX = -300
local minY = -150
local minZ = -50
local maxX = w+300
local maxY = h+150
local maxZ = 150

for x = minX,maxX,q do
  for y = minY,maxY,q do
    if x <= 0 or x >= w or y <= 0 or y >= h then
      AddLineToMesh(meshes[1],{{x,y,minZ},{x,y,maxZ}},{startColor,endColor})
    end
  end
end