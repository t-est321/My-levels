local width = 1000fx
local height = 600fx
pewpew.set_level_size(width,height)

local background = pewpew.new_customizable_entity(0fx,0fx)
pewpew.customizable_entity_set_mesh(background,"/dynamic/assets/background.lua",0)
pewpew.customizable_entity_start_spawning(background,140)
pewpew.customizable_entity_configure_music_response(background,{color_start = 0xff323244,color_end = 0xff3232aa,scale_z_start = 1fx,scale_z_end = 2fx})

local weapon_config = {frequency = pewpew.CannonFrequency.FREQ_15,cannon = pewpew.CannonType.TRIPLE}
local ship = pewpew.new_player_ship(500fx,300fx,0)
pewpew.configure_player(0,{camera_distance = -125fx,shield = 2})
pewpew.configure_player_ship_weapon(ship,weapon_config)

local function random_position()
  return fmath.random_fixedpoint(0fx,width),fmath.random_fixedpoint(0fx,height)
end

local time = 0
pewpew.add_update_callback(function()
  time = time+1
  local conf = pewpew.get_player_configuration(0)
  if conf["has_lost"] then
    pewpew.stop_game()
  end
  if time %13 == 0 then
    local x,y = random_position()
    pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1350)
  end
  if time %46 == 0 then
    local x,y = random_position()
    pewpew.new_rolling_cube(x,y)
  end
  if time %32 == 0 then
    local x,y = random_position()
    pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),8fx,1350)
    pewpew.new_crowder(x,y)
  end
  if time %70 == 0 then
    local x,y = random_position()
    pewpew.new_asteroid(x,y)
  end
  if time %83 == 0 then
    local x,y = random_position()
    pewpew.new_wary(x,y)
  end
  if time %750 == 0 then
    local x,y = random_position()
    pewpew.new_asteroid(x,y)
    pewpew.new_rolling_cube(x,y)
    pewpew.new_brownian(x,y)
    pewpew.new_crowder(x,y)
    pewpew.new_wary(x,y)
    for count = 1,15 do
      local x,y = random_position()
      pewpew.new_baf(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),15fx,-1)
    end
  end
  if time %600 == 0 then
    local x,y = random_position()
    pewpew.new_bonus(x,y,pewpew.BonusType.SHIELD,{number_of_shields = 1})
  end
  if time %800 == 0 then
    local x,y = random_position()
    pewpew.new_bonus(x,y,pewpew.BonusType.WEAPON,{cannon = pewpew.CannonType.TRIPLE,frequency = pewpew.CannonFrequency.FREQ_30,weapon_duration = 30})
  end
end)