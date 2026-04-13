local width = 1500fx
local height = 1825fx
local time = 0
local burret = require("/dynamic/burret.lua")
pewpew.set_level_size(width,height)
local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end
local background = pewpew.new_customizable_entity(1fx,1fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/graphic.lua",0)
pewpew.configure_player(0,{shield = 3,camera_distance = -350fx})
local ship = pewpew.new_player_ship(width/50fx,height/50fx,0)
pewpew.configure_player_ship_weapon(ship,{frequency = pewpew.CannonFrequency.FREQ_10,cannon = pewpew.CannonType.DOUBLE})

pewpew.add_update_callback(function()
  time = time+1
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if time %30 == 0 then
    local x,y = random_position()
    burret_new(x,y,ship)
  end
end)
-- var: 9