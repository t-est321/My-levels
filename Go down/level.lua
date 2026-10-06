    local width = 500fx
    local height = 1500fx
    pewpew.set_level_size(width, height)

    local background = pewpew.new_customizable_entity(width / 500fx, height / 1500fx)
    pewpew.customizable_entity_set_mesh(background, "/dynamic/graphics.lua", 0)

    local function random_position()
        return fmath.random_fixedpoint(0fx, width), fmath.random_fixedpoint(0fx, height)
    end

  pewpew.configure_player(0, {shield = 5})
  local ship = pewpew.new_player_ship(width / 2fx, height / 2fx, 0)
  pewpew.configure_player_ship_weapon(ship, { frequency = pewpew.CannonFrequency.FREQ_10, cannon = pewpew.CannonType.DOUBLE})
  function clamp(v, min, max)
    return v
  end

    local randomm = fmath.random_int(1,7)
    local hi = pewpew.new_customizable_entity(width / 2fx, height / 2fx+450fx)
    pewpew.customizable_entity_set_string(hi,"#0000ffffGo down")
    local h2i = pewpew.new_customizable_entity(width / 2fx, height / 2fx-550fx)
    if randomm == 1 then
        pewpew.customizable_entity_set_string(h2i,"#0000ffffHi")
    elseif randomm == 2 then
        pewpew.customizable_entity_set_string(h2i,"#0000ffffASasfsdjgfksdNFWIEUFBWIEUFuibdfdsiojfks")
    elseif randomm == 3 then
        pewpew.customizable_entity_set_string(h2i,"#0000ffffHello")
    elseif randomm == 4 then
        pewpew.customizable_entity_set_string(h2i,"#0000ffffGo up")
    elseif randomm == 5 then
        pewpew.customizable_entity_set_string(h2i,"#0000ffff133713371337133713371337133713371337133713371337133713371337133713371337133713371337133713371337133713371337133713371337")
    elseif randomm == 6 then
        pewpew.customizable_entity_set_string(h2i,"#0000ffffYou die")
    elseif randomm == 7 then
        pewpew.customizable_entity_set_string(h2i,"#ff0000ffGame over")
    end
 
    local time = 0
    local mod = 2
    pewpew.add_update_callback(function()
        time = time + 1
        local conf = pewpew.get_player_configuration(0)
        if conf["has_lost"] then
            pewpew.stop_game()
        end
        if time == 500 then
            mod = mod - 1
        end
        if time % mod == 0 then
            local x, y = random_position()
            pewpew.new_baf_blue(x,y,fmath.random_fixedpoint(0fx,fmath.tau()),9fx,-10)
        end
    end)