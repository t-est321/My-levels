local C = require("/dynamic/game_config.lua")

local W = {}

local S = 9fx/10fx

W.SCALE = S

function W.size()
  return C.ARENA_W*S,C.ARENA_H*S
end

function W.new(x,y)
  return pewpew.new_customizable_entity(x*S,y*S)
end

function W.place(id,x,y)
  pewpew.entity_set_position(id,x*S,y*S)
end

function W.pos(id)
  local x,y = pewpew.entity_get_position(id)
  return x,y
end

function W.explode(x,y,color,scale,particles)
  pewpew.create_explosion(x*S,y*S,color,scale*S,particles)
end

function W.mesh_scale(id,scale)
  pewpew.customizable_entity_set_mesh_scale(id,scale*S)
end

function W.mesh_scale3(id,x,y,z)
  pewpew.customizable_entity_set_mesh_xyz_scale(id,x*S,y*S,z)
end

function W.radius(id,radius)
  pewpew.entity_set_radius(id,radius*S)
end

function W.vis(id,radius)
  pewpew.customizable_entity_set_visibility_radius(id,radius*S)
end

function W.wall(x1,y1,x2,y2)
  return pewpew.add_wall(x1*S,y1*S,x2*S,y2*S)
end

function W.msg(x,y,str,config)
  local cfg = {scale = 1fx,ticks_before_fade = 30,is_optional = false}
  if config ~= nil then
    cfg.scale = config.scale or 1fx
    cfg.ticks_before_fade = config.ticks_before_fade or 30
    cfg.is_optional = config.is_optional or false
    if config.dz ~= nil then
      cfg.dz = config.dz*S
    end
  end
  cfg.scale = cfg.scale*S
  return pewpew.new_floating_message(x*S,y*S,str,cfg)
end

return W
