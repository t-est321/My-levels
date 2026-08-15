pewpew.set_level_size(600fx,600fx)

local ship = pewpew.new_player_ship(300fx,300fx,0)
pewpew.configure_player(0,{camera_distance = -125fx,shield = 3})
local background = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/graphic.lua",0)

local add_p = pewpew.add_particle
local rnd_f = fmath.random_fixedpoint
local old_px = 300fx-- ship x
local old_py = 300fx-- ship y
local time = 0
local initialized = false

pewpew.add_update_callback(function()
  time = time+1
  if pewpew.entity_get_is_alive(ship) then
    local px,py = pewpew.entity_get_position(ship)
    if initialized then
      local dx = px-old_px
      local dy = py-old_py
      if dx ~= 0fx or dy ~= 0fx then
        add_p(px,py,0fx,-dx+rnd_f(-3fx,3fx),-dy+rnd_f(-3fx,3fx),0fx,0x46a0ffff,64)
        add_p(px,py,0fx,-dx+rnd_f(-3fx,3fx),-dy+rnd_f(-3fx,3fx),0fx,0x2060ccff,48)
        add_p(px,py,0fx,-dx+rnd_f(-4fx,4fx),-dy+rnd_f(-4fx,4fx),0fx,0xffffffff,24)
      end
    else
      initialized = true
    end
    old_px = px-- new ship x
    old_py = py-- new ship y
  end
end)