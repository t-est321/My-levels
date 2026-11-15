local C = require("/dynamic/game_config.lua")
local S = require("/dynamic/state.lua")
local P = require("/dynamic/progress.lua")
local R = require("/dynamic/rng.lua")
local campaign = require("/dynamic/campaign.lua")
local E = require("/dynamic/entities.lua")
local B = require("/dynamic/boss.lua")
local I = require("/dynamic/interface.lua")
local W = require("/dynamic/world.lua")

local STATE = C.STATE

local boot_ticks = 0
local crash_ticks = 0
local intro_ticks = 0
local title_help = false

local function clamp(value,low,high)
  if value < low then
    return low
  end
  if value > high then
    return high
  end
  return value
end

local function park_ship()
  S.bar_x = C.MENU_X
  S.bar_y = C.MENU_Y
  S.bar_vx = 0fx
  S.bar_vy = 0fx
end

local function set_state(value)
  S.state = value
  S.state_tick = 0
  if value == STATE.TITLE or value == STATE.RESULTS or value == STATE.GAMEOVER or value == STATE.COMPLETE or value == STATE.INTRO or value == STATE.HELP then
    S.menu_armed = false
    S.menu_push = false
  end
end

local function apply_difficulty()
  local diff = C.DIFF[S.difficulty] or C.DIFF.NORMAL
  S.score_mul_num = diff.num
  S.score_mul_den = diff.den
  S.diff_speed = diff.speed
  S.diff_density = diff.density
  S.diff_red = diff.red
  S.diff_warn = diff.warn
  S.max_lives = diff.lives
  S.charge_bonus = diff.charge_bonus
end

local function copy_charges(def)
  local bonus = S.charge_bonus or {scan = 0,firewall = 0,defrag = 0,slow = 0}
  local keys = {"scan","firewall","defrag","slow"}
  local charges = {}
  for i = 1,#keys do
    local key = keys[i]
    local value = def.charges[key]+bonus[key]
    if value < 0 then
      value = 0
    end
    charges[key] = value
  end
  return charges
end

local function add_bonus(points,label,lines)
  if points <= 0 then
    return 0
  end
  local value = points*S.score_mul_num//S.score_mul_den
  if value < 1 then
    value = 1
  end
  lines[#lines+1] = label.." +"..tostring(value)
  return value
end

local function total_levels()
  return #campaign.levels
end

local function start_level()
  local def = nil
  if S.overclock then
    def = campaign.overclock(S.overclock_wave)
  else
    def = campaign.levels[S.level]
  end
  S.def = def
  apply_difficulty()
  R.seed(def.seed+S.level*17+S.overclock_wave*101)
  S.lives = S.max_lives
  S.bar_x = C.BAR_START_X
  S.bar_y = C.BAR_START_Y
  E.level_reset(def)
  S.charges = copy_charges(def)
  S.slow_timer = 0
  S.time_scale = 1fx
  S.firewall_timer = 0
  S.invuln = 0
  S.level_score_start = pewpew.get_score_of_player(0)
  S.level_time = 0
  S.result = nil
  S.terminal = false
  S.screen_dirty = true
  pewpew.configure_player(0,{shield = S.lives})
  intro_ticks = 0
  I.hide_world()
  I.screen_intro(S.level,def)
  set_state(STATE.INTRO)
end

local function enter_play()
  I.screen_clear()
  I.show_world()
  I.reset_messages()
  S.invuln = C.INVULN_TICKS
  S.screen_dirty = true
  S.bar_x = C.BAR_START_X
  S.bar_y = C.BAR_START_Y
  S.combo_count = 0
  S.combo_timer = 0
  S.combo_mult_num = 1
  S.combo_mult_den = 1
  I.draw_cells()
  set_state(STATE.PLAY)
end

local function enter_title()
  I.hide_world()
  title_help = false
  park_ship()
  I.screen_title(S.difficulty,S.unlocked_hardcore,S.unlocked_overclock,S.menu_sel)
  set_state(STATE.TITLE)
end

local function enter_gameover()
  I.hide_world()
  park_ship()
  S.terminal = true
  S.menu_sel = 1
  local lines = {
    "FINAL SCORE "..tostring(pewpew.get_score_of_player(0)),
    "LEVEL REACHED "..tostring(S.level),
    "DIFFICULTY "..S.difficulty
  }
  I.screen_overlay("GAME OVER","THE SYSTEM WON THIS ROUND",lines,{"RETRY LEVEL","RESTART CAMPAIGN"},1,0xff2b4aff)
  set_state(STATE.GAMEOVER)
end

local function enter_complete()
  I.hide_world()
  park_ship()
  S.terminal = true
  S.menu_sel = 1
  local score = pewpew.get_score_of_player(0)
  local rank = "BRONZE"
  if score > 30000 then
    rank = "GOLD"
  elseif score > 15000 then
    rank = "SILVER"
  end
  local lines = {
    "CAMPAIGN COMPLETE",
    "TOTAL SCORE "..tostring(score),
    "RANK "..rank,
    "OVERCLOCK UNLOCKED",
    "TIME PLAYED "..tostring(S.campaign_ticks//30).."S"
  }
  I.screen_overlay("SYSTEM OVERDRIVE","ALL 40 LEVELS PURGED",lines,{"START ENDLESS OVERCLOCK","RESTART CAMPAIGN"},1,0x33ff88ff)
  S.unlocked_overclock = true
  set_state(STATE.COMPLETE)
end

local function complete_level()
  if S.terminal then
    return
  end
  S.terminal = true
  local correct = P.correct_percent()
  local filled = P.percent()
  local level_score = pewpew.get_score_of_player(0)-S.level_score_start
  local bonus_total = 0
  local lines = {}
  bonus_total = bonus_total+add_bonus(C.SCORE_COMPLETE,"COMPLETION",lines)
  if correct >= 100 then
    bonus_total = bonus_total+add_bonus(C.SCORE_PURITY,"PERFECT RATING",lines)
  end
  if S.damage == 0 then
    bonus_total = bonus_total+add_bonus(C.SCORE_NODAMAGE,"NO DAMAGE",lines)
  end
  if S.level_time <= S.def.par then
    bonus_total = bonus_total+add_bonus(C.SCORE_SPEED,"SPEED BONUS",lines)
  end
  if S.gray_at_zero >= 5 then
    bonus_total = bonus_total+add_bonus(C.SCORE_NULL,"NULL CHALLENGE",lines)
  end
  if S.pink_at_zero >= 3 then
    bonus_total = bonus_total+add_bonus(C.SCORE_MAGIC,"MAGIC PINK",lines)
  end
  if bonus_total > 0 then
    pewpew.increase_score_of_player(0,bonus_total)
  end
  S.campaign_score = pewpew.get_score_of_player(0)
  S.result = {
    filled = filled,
    correct = correct,
    time = S.level_time,
    level_score = level_score,
    bonus = bonus_total,
    total = S.campaign_score
  }
  if not S.overclock then
    if S.level == C.HARDCORE_UNLOCK then
      S.unlocked_hardcore = true
    end
    if S.level == C.OVERCLOCK_UNLOCK then
      S.unlocked_overclock = true
    end
  end
  S.def_complete = true
  local rows = {}
  rows[#rows+1] = "CORRECT "..tostring(correct).."%   PROGRESS "..tostring(filled).."%"
  rows[#rows+1] = "TIME "..tostring(S.level_time//30).."S   PAR "..tostring(S.def.par//30).."S"
  for i = 1,#lines do
    rows[#rows+1] = lines[i]
  end
  rows[#rows+1] = "LEVEL SCORE "..tostring(level_score)
  rows[#rows+1] = "TOTAL SCORE "..tostring(S.campaign_score)
  if not S.overclock and S.level < total_levels() then
    rows[#rows+1] = "NEXT: "..tostring(S.level+1).." "..campaign.levels[S.level+1].title
  elseif S.unlocked_overclock and not S.overclock then
    rows[#rows+1] = "OVERCLOCK UNLOCKED AT THE TITLE"
  end
  I.hide_world()
  I.screen_results(rows,1)
  set_state(STATE.RESULTS)
  pewpew.play_sound(C.SOUND,10,500fx,400fx)
  W.explode(500fx,400fx,C.PAL.green,3fx,40)
end

local function crash(reason)
  if S.state ~= STATE.PLAY or S.terminal or S.invuln > 0 then
    return
  end
  S.terminal = true
  S.lives = S.lives-1
  S.combo_count = 0
  S.combo_timer = 0
  S.damage = S.damage+1
  S.crash_count = S.crash_count+1
  E.crash_cleanup(S.bar_x,S.bar_y)
  W.explode(S.bar_x,S.bar_y,C.PAL.red,3fx,50)
  W.explode(S.bar_x,S.bar_y,C.PAL.white,2fx,30)
  pewpew.play_sound(C.SOUND,2,S.bar_x,S.bar_y)
  if S.lives > 0 then
    pewpew.play_sound(C.SOUND,17,S.bar_x,S.bar_y)
  else
    pewpew.play_sound(C.SOUND,18,S.bar_x,S.bar_y)
  end
  pewpew.configure_player(0,{shield = S.lives})
  I.screen_crash()
  crash_ticks = C.CRASH_TICKS
  set_state(STATE.CRASH)
end

S.hooks.crash = crash
S.hooks.message = function(value)
  I.message(value)
end
S.hooks.filled_percent = function()
  return P.percent()
end

local function shoot_direction()
  local sin = select(1,fmath.sincos(S.in_sa))
  local cos = select(2,fmath.sincos(S.in_sa))
  if fmath.abs_fixedpoint(sin) > fmath.abs_fixedpoint(cos) then
    if sin > 0fx then
      return "up"
    end
    return "down"
  end
  if cos > 0fx then
    return "right"
  end
  return "left"
end

local last_shoot = false
local last_dir = nil
local menu_lock = 0

local function poll_inputs()
  local ma,md,sa,sd = pewpew.get_player_inputs(0)
  S.in_ma = ma
  S.in_md = md
  S.in_sa = sa
  S.in_sd = sd
  local pressed = sd > C.SHOOT_PRESS
  local dir = nil
  if pressed then
    dir = shoot_direction()
  end
  S.shoot_edge = pressed and not last_shoot
  S.shoot_down = pressed
  S.shoot_dir = dir
  if S.in_md < C.MOVE_DEADZONE then
    S.menu_armed = true
  end
  S.util_edge = false
  if last_shoot and dir ~= nil and dir ~= last_dir and S.util_lock == 0 then
    S.util_edge = true
  end
  last_shoot = pressed
  last_dir = dir
end

local function use_utility()
  local direction = S.shoot_dir or shoot_direction()
  if S.state ~= STATE.PLAY then
    return
  end
  S.util_lock = C.UTIL_LOCK
  if direction == "up" then
    if S.charges.scan > 0 then
      S.charges.scan = S.charges.scan-1
      S.charges_used = S.charges_used+1
      S.scan_uses = S.scan_uses+1
      E.scan(S.bar_x,S.bar_y)
      pewpew.play_sound(C.SOUND,7,S.bar_x,S.bar_y)
    else
      I.message("NO SCAN CHARGE")
      pewpew.play_sound(C.SOUND,14,S.bar_x,S.bar_y)
    end
  elseif direction == "right" then
    if S.charges.firewall > 0 then
      S.charges.firewall = S.charges.firewall-1
      S.charges_used = S.charges_used+1
      S.firewall_timer = C.FIREWALL_TICKS
      I.message("FIREWALL ONLINE")
      pewpew.play_sound(C.SOUND,7,S.bar_x,S.bar_y)
      W.explode(S.bar_x,S.bar_y,C.PAL.cyan,2fx,20)
    else
      I.message("NO FIREWALL CHARGE")
      pewpew.play_sound(C.SOUND,14,S.bar_x,S.bar_y)
    end
  elseif direction == "down" then
    if S.charges.defrag > 0 then
      S.charges.defrag = S.charges.defrag-1
      S.charges_used = S.charges_used+1
      E.defrag()
    else
      I.message("NO DEFRAG CHARGE")
      pewpew.play_sound(C.SOUND,14,S.bar_x,S.bar_y)
    end
  else
    if S.charges.slow > 0 then
      S.charges.slow = S.charges.slow-1
      S.charges_used = S.charges_used+1
      S.slow_timer = C.SLOW_TICKS
      S.time_scale = 1fx/2fx
      I.message("TIME DILATION")
      pewpew.play_sound(C.SOUND,7,S.bar_x,S.bar_y)
    else
      I.message("NO SLOW CHARGE")
      pewpew.play_sound(C.SOUND,14,S.bar_x,S.bar_y)
    end
  end
end

local function move_bar(dt)
  local md = S.in_md
  local target_x = 0fx
  local target_y = 0fx
  if md > C.MOVE_DEADZONE then
    local sin = select(1,fmath.sincos(S.in_ma))
    local cos = select(2,fmath.sincos(S.in_ma))
    local speed = C.BAR_SPEED*md
    target_x = cos*speed
    target_y = sin*speed
  end
  local blend = 1fx/C.BAR_SMOOTH
  S.bar_vx = S.bar_vx+(target_x-S.bar_vx)*blend
  S.bar_vy = S.bar_vy+(target_y-S.bar_vy)*blend
  S.bar_x = clamp(S.bar_x+S.bar_vx*dt,C.BAR_MIN_X,C.BAR_MAX_X)
  S.bar_y = clamp(S.bar_y+S.bar_vy*dt,C.BAR_MIN_Y,C.BAR_MAX_Y)
end

local function menu_move(count)
  if menu_lock > 0 then
    menu_lock = menu_lock-1
    return
  end
  if not S.menu_armed then
    return
  end
  if S.in_md < 1fx/2fx then
    S.menu_push = false
    return
  end
  if S.menu_push then
    return
  end
  S.menu_push = true
  local sin = select(1,fmath.sincos(S.in_ma))
  if sin > 1fx/2fx then
    S.menu_sel = S.menu_sel-1
    if S.menu_sel < 1 then
      S.menu_sel = count
    end
    menu_lock = 10
    I.move_selection(S.menu_sel)
    pewpew.play_sound(C.SOUND,12,500fx,350fx)
  elseif sin < -1fx/2fx then
    S.menu_sel = S.menu_sel+1
    if S.menu_sel > count then
      S.menu_sel = 1
    end
    menu_lock = 10
    I.move_selection(S.menu_sel)
    pewpew.play_sound(C.SOUND,12,500fx,350fx)
  end
end

local function difficulty_available(name)
  if name == "HARDCORE" then
    return S.unlocked_hardcore
  end
  return true
end

local function cycle_difficulty(step)
  local order = C.DIFF_ORDER
  local index = 1
  for i = 1,#order do
    if order[i] == S.difficulty then
      index = i
    end
  end
  for _ = 1,#order do
    index = index+step
    if index > #order then
      index = 1
    end
    if index < 1 then
      index = #order
    end
    if difficulty_available(order[index]) then
      break
    end
  end
  S.difficulty = order[index]
  apply_difficulty()
  I.screen_title(S.difficulty,S.unlocked_hardcore,S.unlocked_overclock,S.menu_sel)
  pewpew.play_sound(C.SOUND,13,500fx,350fx)
end

local function update_boot()
  boot_ticks = boot_ticks+1
  if S.shoot_edge or boot_ticks > 130 then
    enter_title()
  end
end

local function update_title()
  local count = 4
  menu_move(count)
  if S.shoot_edge then
    pewpew.play_sound(C.SOUND,13,500fx,400fx)
    if S.menu_sel == 1 then
      S.overclock = false
      if not difficulty_available(S.difficulty) or S.difficulty == "OVERCLOCK" then
        S.difficulty = "NORMAL"
        apply_difficulty()
      end
      S.level = 1
      S.campaign_ticks = 0
      pewpew.increase_score_of_player(0,0)
      start_level()
    elseif S.menu_sel == 2 then
      cycle_difficulty(1)
    elseif S.menu_sel == 3 then
      if S.unlocked_overclock then
        S.overclock = true
        S.overclock_wave = 1
        S.difficulty = "OVERCLOCK"
        start_level()
      else
        I.message("COMPLETE LEVEL "..tostring(C.OVERCLOCK_UNLOCK).." FIRST")
      end
    else
      set_state(STATE.HELP)
      I.screen_help(1,1)
    end
  end
end

local function update_intro()
  intro_ticks = intro_ticks+1
  if S.shoot_edge or intro_ticks > 240 then
    enter_play()
  end
end

local function update_play()
  local dt = S.time_scale
  if S.slow_timer > 0 then
    S.slow_timer = S.slow_timer-1
    if S.slow_timer == 0 then
      S.time_scale = 1fx
      dt = 1fx
    end
  end
  if S.firewall_timer > 0 then
    S.firewall_timer = S.firewall_timer-1
  end
  if S.invuln > 0 then
    S.invuln = S.invuln-1
  end
  S.level_time = S.level_time+1
  if S.util_lock > 0 then
    S.util_lock = S.util_lock-1
  end
  if S.shoot_edge or S.util_edge then
    use_utility()
  end
  if S.state ~= STATE.PLAY then
    return
  end
  move_bar(dt)
  E.update(dt)
  E.collide()
  if S.state ~= STATE.PLAY then
    return
  end
  E.spawn_tick(dt)
  if S.pending_complete or (P.full() and B.done()) then
    S.pending_complete = false
    complete_level()
  end
end

local function update_crash()
  crash_ticks = crash_ticks-1
  if crash_ticks > 0 then
    return
  end
  if S.lives > 0 then
    I.screen_clear()
    I.show_world()
    S.terminal = false
    S.invuln = C.INVULN_TICKS
    S.screen_dirty = true
    set_state(STATE.PLAY)
  else
    enter_gameover()
  end
end

local function update_results()
  menu_move(2)
  if S.shoot_edge then
    if S.menu_sel == 1 then
      pewpew.play_sound(C.SOUND,13,500fx,400fx)
      if S.overclock then
        S.overclock_wave = S.overclock_wave+1
        start_level()
      elseif S.level >= total_levels() then
        enter_complete()
      else
        S.level = S.level+1
        start_level()
      end
    else
      pewpew.play_sound(C.SOUND,12,500fx,400fx)
      start_level()
    end
  end
end

local function update_gameover()
  menu_move(2)
  if S.shoot_edge then
    if S.menu_sel == 1 then
      start_level()
    else
      S.overclock = false
      S.level = 1
      S.difficulty = "NORMAL"
      apply_difficulty()
      pewpew.increase_score_of_player(0,-pewpew.get_score_of_player(0))
      enter_title()
    end
  end
end

local function update_complete()
  menu_move(2)
  if S.shoot_edge then
    if S.menu_sel == 1 then
      S.overclock = true
      S.overclock_wave = 1
      S.difficulty = "OVERCLOCK"
      start_level()
    else
      S.overclock = false
      S.level = 1
      S.difficulty = "NORMAL"
      apply_difficulty()
      pewpew.increase_score_of_player(0,-pewpew.get_score_of_player(0))
      enter_title()
    end
  end
end

local function update_help()
  if menu_lock > 0 then
    menu_lock = menu_lock-1
    return
  end
  if not S.menu_armed then
    return
  end
  if S.shoot_edge then
    set_state(STATE.TITLE)
    S.menu_sel = 4
    I.screen_title(S.difficulty,S.unlocked_hardcore,S.unlocked_overclock,S.menu_sel)
    return
  end
  if S.in_md < 1fx/2fx then
    return
  end
  local sin = select(1,fmath.sincos(S.in_ma))
  local pages = C.HELP_PAGES
  if sin > 1fx/2fx then
    S.menu_sel = S.menu_sel+1
    if S.menu_sel > pages then S.menu_sel = 1 end
    menu_lock = 10
    I.screen_help(S.menu_sel,S.menu_sel)
    pewpew.play_sound(C.SOUND,12,500fx,350fx)
  elseif sin < -1fx/2fx then
    S.menu_sel = S.menu_sel-1
    if S.menu_sel < 1 then S.menu_sel = pages end
    menu_lock = 10
    I.screen_help(S.menu_sel,S.menu_sel)
    pewpew.play_sound(C.SOUND,12,500fx,350fx)
  end
end

local function update_callback()
  S.tick = S.tick+1
  S.state_tick = S.state_tick+1
  pewpew.configure_player(0,{camera_x_override = C.CAM_X*9fx/10fx,camera_y_override = C.CAM_Y*9fx/10fx})
  poll_inputs()
  local state = S.state
  if state == STATE.BOOT then
    update_boot()
  elseif state == STATE.TITLE then
    update_title()
  elseif state == STATE.INTRO then
    update_intro()
  elseif state == STATE.PLAY then
    update_play()
  elseif state == STATE.CRASH then
    update_crash()
  elseif state == STATE.RESULTS then
    update_results()
  elseif state == STATE.GAMEOVER then
    update_gameover()
  elseif state == STATE.HELP then
    update_help()
  end
  if S.state == STATE.PLAY or S.state == STATE.CRASH or S.state == STATE.HELP then
    I.update()
  end
  S.campaign_ticks = S.campaign_ticks+1
end

pewpew.set_level_size(W.size())
pewpew.configure_player(0,{
  shield = 3,
  move_joystick_color = 0x22d3eeff,
  shoot_joystick_color = 0xff3ba0ff
})
apply_difficulty()
I.init()
S.lives = S.max_lives
I.hide_world()
I.screen_overlay("PROGRESSBAR 95","SYSTEM OVERDRIVE",{"BOOTING OPTIONAL PERIPHERALS","LOADING DESKTOP","CALIBRATING PROGRESS BAR"},{"PRESS SHOOT TO SKIP"},0,0x0f3b4aff)
pewpew.add_update_callback(update_callback)
