local C = require("/dynamic/game_config.lua")
local S = require("/dynamic/state.lua")
local P = require("/dynamic/progress.lua")
local R = require("/dynamic/rng.lua")
local B = require("/dynamic/boss.lua")
local W = require("/dynamic/world.lua")
local bag = require("/dynamic/bag.lua")

local E = {}

local LANES = {110fx,300fx,500fx,700fx,890fx}

local function sound(index,x,y)
  pewpew.play_sound(C.SOUND,index,x,y)
end

local function message(text)
  if S.hooks.message then
    S.hooks.message(text)
  end
end

local function add_score(points)
  if points <= 0 then
    return
  end
  local value = points*S.score_mul_num//S.score_mul_den
  if value < 1 then
    value = 1
  end
  pewpew.increase_score_of_player(0,value)
end

local function combo_multiplier()
  local c = S.combo_count
  if c >= C.COMBO_TIER_4 then
    return C.COMBO_MULT_4,10
  end
  if c >= C.COMBO_TIER_3 then
    return C.COMBO_MULT_3,10
  end
  if c >= C.COMBO_TIER_2 then
    return C.COMBO_MULT_2,10
  end
  if c >= C.COMBO_TIER_1 then
    return C.COMBO_MULT_1,10
  end
  return 10,10
end

local function add_score_combo(points)
  if points <= 0 then
    return
  end
  local num,den = combo_multiplier()
  local value = points*S.score_mul_num*num//(S.score_mul_den*den)
  if value < 1 then
    value = 1
  end
  pewpew.increase_score_of_player(0,value)
end

local function combo_build()
  S.combo_count = S.combo_count+1
  if S.combo_count > S.combo_max then
    S.combo_max = S.combo_count
  end
  S.combo_timer = 0
end

local function combo_reset()
  S.combo_count = 0
  S.combo_timer = 0
end

local function streak_add(value)
  pewpew.increase_score_streak_of_player(0,value)
end

local function alive(id)
  return id ~= nil and pewpew.entity_get_is_alive(id)
end

function E.budget()
  return #S.seg_order+#S.pop_order+#S.shot_order
end

local function free_segment_slot()
  if #S.seg_order >= C.MAX_SEGMENTS then
    return false
  end
  if E.budget() >= C.MAX_ENTITIES-20 then
    return false
  end
  return true
end

function E.clear_all()
  for i = 1,#S.seg_order do
    local rec = S.seg[S.seg_order[i]]
    if rec ~= nil then
      if alive(rec.id) then
        pewpew.entity_destroy(rec.id)
      end
      if alive(rec.label) then
        pewpew.entity_destroy(rec.label)
      end
    end
    S.seg[S.seg_order[i]] = nil
  end
  S.seg = {}
  S.seg_order = {}
  for i = 1,#S.pop_order do
    local rec = S.pop[S.pop_order[i]]
    if rec ~= nil then
      if alive(rec.id) then
        pewpew.entity_destroy(rec.id)
      end
      if alive(rec.extra) then
        pewpew.entity_destroy(rec.extra)
      end
      if alive(rec.label) then
        pewpew.entity_destroy(rec.label)
      end
    end
    S.pop[S.pop_order[i]] = nil
  end
  S.pop = {}
  S.pop_order = {}
  for i = 1,#S.shot_order do
    local rec = S.shot[S.shot_order[i]]
    if rec ~= nil and alive(rec.id) then
      pewpew.entity_destroy(rec.id)
    end
    S.shot[S.shot_order[i]] = nil
  end
  S.shot = {}
  S.shot_order = {}
  if S.zone_id ~= nil and alive(S.zone_id) then
    pewpew.entity_destroy(S.zone_id)
  end
  S.zone_id = nil
  B.clear()
end

local function seg_kind_for_spawn()
  local kind = bag.next(S.def)
  if kind == C.RED and S.red_live >= S.def.red_limit then
    kind = C.GRAY
  end
  if (kind == C.CYAN2 or kind == C.CYAN3) and S.cyan_live >= S.def.cyan_limit then
    kind = C.BLUE
  end
  if kind == C.GREEN and S.green_spawned >= S.def.green_limit then
    kind = C.BLUE
  end
  if kind == C.RANDOM and #S.seg_order < 3 then
    kind = C.BLUE
  end
  return kind
end

local function label_for(kind)
  return C.SEG[kind].symbol
end

local function make_segment(kind,x,y,vx,vy,wobble)
  if not free_segment_slot() then
    return nil
  end
  local id = W.new(x,y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,C.SEG[kind].mesh)
  pewpew.customizable_entity_set_mesh_color(id,C.SEG[kind].color)
  W.vis(id,90fx)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  W.radius(id,C.SEG_HALF)
  pewpew.customizable_entity_start_spawning(id,0)
  local label = W.new(x,y)
  pewpew.customizable_entity_set_string(label,label_for(kind))
  pewpew.customizable_entity_set_mesh_color(label,C.PAL.white)
  W.mesh_scale(label,1fx/2fx)
  W.vis(label,90fx)
  pewpew.customizable_entity_set_position_interpolation(label,true)
  local rec = {
    id = id,
    label = label,
    kind = kind,
    base_kind = kind,
    x = x,
    y = y,
    base_x = x,
    vx = vx,
    vy = vy,
    wob = wobble,
    phase = fmath.to_fixedpoint(R.int(0,359))*fmath.tau()/360fx,
    spin = 0fx,
    roll = 0,
    resolved = false,
    born = S.level_tick,
    decoy = false
  }
  if kind == C.RANDOM then
    rec.roll = R.int(0,4)
  end
  if S.def.modifier == "decoy" or S.def.modifier == "phantom" or S.def.modifier == "triad_three" then
    if kind == C.BLUE and R.chance(18) then
      rec.decoy = true
      pewpew.customizable_entity_set_mesh_color(id,C.PAL.dim)
    end
  end
  S.seg[id] = rec
  S.seg_order[#S.seg_order+1] = id
  if kind == C.RED then
    S.red_live = S.red_live+1
  end
  if kind == C.CYAN2 or kind == C.CYAN3 then
    S.cyan_live = S.cyan_live+1
  end
  if kind == C.GREEN then
    S.green_spawned = S.green_spawned+1
  end
  if kind == C.BLUE then
    S.spawn_pity = 0
  else
    S.spawn_pity = S.spawn_pity+1
  end
  return rec
end

local function kill_segment(rec)
  if rec == nil then
    return
  end
  if alive(rec.id) then
    pewpew.entity_destroy(rec.id)
  end
  if alive(rec.label) then
    pewpew.entity_destroy(rec.label)
  end
  if rec.kind == C.RED and S.red_live > 0 then
    S.red_live = S.red_live-1
  end
  if (rec.kind == C.CYAN2 or rec.kind == C.CYAN3) and S.cyan_live > 0 then
    S.cyan_live = S.cyan_live-1
  end
  S.seg[rec.id] = nil
  rec.resolved = true
end

local function roll_random(rec)
  local weights = S.def.weights
  local total = weights.blue+weights.yellow+weights.pink+weights.gray+weights.red
  if total <= 0 then
    total = 100
    weights = {blue = 45,yellow = 20,pink = 15,gray = 12,red = 8}
  end
  local roll = R.int(1,total)
  if roll <= weights.blue then
    return C.BLUE
  end
  roll = roll-weights.blue
  if roll <= weights.yellow then
    return C.YELLOW
  end
  roll = roll-weights.yellow
  if roll <= weights.pink then
    return C.PINK
  end
  roll = roll-weights.pink
  if roll <= weights.gray then
    return C.GRAY
  end
  return C.RED
end

local function bar_hits(x,y,half_x,half_y)
  if y+half_y < S.bar_y-C.BAR_HH then
    return false
  end
  if y-half_y > S.bar_y+C.BAR_HH then
    return false
  end
  if x+half_x < S.bar_x-C.BAR_HW then
    return false
  end
  if x-half_x > S.bar_x+C.BAR_HW then
    return false
  end
  return true
end

function E.on_blue(rec,amount)
  local added = P.add_correct(amount)
  S.blue_taken = S.blue_taken+added
  add_score_combo(C.SEG[rec.kind].score*added)
  streak_add(1)
  combo_build()
  S.screen_dirty = true
  W.explode(rec.x,rec.y,C.SEG[rec.kind].color,1fx,10)
  sound(0,rec.x,rec.y)
  if added < amount then
    message("BAR CLAMPED")
  end
end

function E.on_cyan(rec,amount)
  local added = P.add_correct(amount)
  S.blue_taken = S.blue_taken+added
  add_score_combo(C.SEG[rec.kind].score)
  streak_add(1)
  combo_build()
  S.screen_dirty = true
  W.explode(rec.x,rec.y,C.SEG[rec.kind].color,13fx/10fx,14)
  sound(6,rec.x,rec.y)
  if added < amount then
    message("BAR CLAMPED")
  end
end

function E.on_yellow(rec)
  local added = P.add_corrupt(1)
  S.yellow_taken = S.yellow_taken+added
  add_score(C.SEG[C.YELLOW].score)
  streak_add(-1)
  S.screen_dirty = true
  W.explode(rec.x,rec.y,C.SEG[C.YELLOW].color,1fx,8)
  sound(1,rec.x,rec.y)
  if S.boss_corrupt and S.boss ~= nil then
    message("CORRUPTION SPREADS")
  end
end

function E.on_pink(rec)
  local removed = P.remove_last()
  S.screen_dirty = true
  if P.filled() == 0 and S.level_tick > 0 then
    S.pink_at_zero = S.pink_at_zero+1
  end
  W.explode(rec.x,rec.y,C.SEG[C.PINK].color,1fx,10)
  sound(3,rec.x,rec.y)
  if removed then
    message("PROGRESS LOST")
    streak_add(-2)
  else
    message("NOTHING TO REMOVE")
  end
end

function E.on_gray(rec)
  add_score(C.SEG[C.GRAY].score)
  if P.filled() == 0 then
    S.gray_at_zero = S.gray_at_zero+1
    if S.gray_at_zero == 1 then
      message("NULL POINTER TRACKING")
    end
  end
  W.explode(rec.x,rec.y,C.SEG[C.GRAY].color,1fx/2fx,6)
  sound(4,rec.x,rec.y)
end

function E.on_green(rec)
  if S.green_used then
    E.on_blue(rec,2)
    return
  end
  S.green_used = true
  P.fill_all()
  S.screen_dirty = true
  add_score(C.SEG[C.GREEN].score)
  W.explode(rec.x,rec.y,C.SEG[C.GREEN].color,3fx,40)
  W.explode(rec.x,rec.y,C.PAL.white,2fx,30)
  sound(5,rec.x,rec.y)
  message("GREEN KEY")
  S.pending_complete = true
end

local function consume_firewall(x,y)
  if S.firewall_timer <= 0 then
    return false
  end
  S.firewall_timer = 0
  S.firewall_uses = S.firewall_uses+1
  W.explode(x,y,C.PAL.cyan,2fx,20)
  sound(15,x,y)
  message("FIREWALL BLOCK")
  return true
end

function E.resolve(rec)
  if rec == nil or rec.resolved then
    return
  end
  local kind = rec.kind
  if rec.decoy then
    kind = C.GRAY
  end
  if kind == C.RANDOM then
    kind = roll_random(rec)
    if kind == C.RED then
      if S.red_live >= S.def.red_limit then
        kind = C.GRAY
      else
        S.red_live = S.red_live+1
      end
    end
    rec.kind = kind
  end
  rec.resolved = true
  if kind == C.RED then
    if S.invuln > 0 then
      W.explode(rec.x,rec.y,C.SEG[C.RED].color,1fx,10)
      return
    end
    if consume_firewall(rec.x,rec.y) then
      add_score(5)
      return
    end
    combo_reset()
    if S.hooks.crash then
      S.hooks.crash("red segment")
    end
    return
  end
  if kind == C.PINK then
    if consume_firewall(rec.x,rec.y) then
      return
    end
    E.on_pink(rec)
    return
  end
  if kind == C.BLUE then
    E.on_blue(rec,1)
  elseif kind == C.CYAN2 then
    E.on_cyan(rec,2)
  elseif kind == C.CYAN3 then
    E.on_cyan(rec,3)
  elseif kind == C.YELLOW then
    E.on_yellow(rec)
  elseif kind == C.GRAY then
    E.on_gray(rec)
  elseif kind == C.GREEN then
    E.on_green(rec)
  end
end

local function update_random_visual(rec)
  if rec.kind ~= C.RANDOM then
    return
  end
  if S.level_tick%24 ~= 0 then
    return
  end
  rec.roll = (rec.roll+1)%5
  local visual = {C.BLUE,C.YELLOW,C.PINK,C.GRAY,C.RED}
  local kind = visual[rec.roll+1]
  rec.kind = kind
  pewpew.customizable_entity_set_mesh(rec.id,C.MESH,C.SEG[kind].mesh)
  pewpew.customizable_entity_set_mesh_color(rec.id,C.SEG[kind].color)
end

local function update_segments(dt)
  local compact = false
  for i = 1,#S.seg_order do
    local id = S.seg_order[i]
    local rec = S.seg[id]
    if rec == nil then
      compact = true
    elseif not alive(rec.id) then
      kill_segment(rec)
      compact = true
    else
      local speed_scale = dt
      if S.freeze_timer > 0 then
        speed_scale = 0fx
      end
      if S.boost_timer > 0 then
        speed_scale = speed_scale*7fx/5fx
      end
      rec.phase = rec.phase+speed_scale/8fx
      rec.base_x = rec.base_x+rec.vx*speed_scale
      if S.def.modifier == "bounce" or S.def.modifier == "triad" then
        if rec.base_x < 30fx then
          rec.base_x = 30fx
          rec.vx = -rec.vx
        end
        if rec.base_x > C.ARENA_W-30fx then
          rec.base_x = C.ARENA_W-30fx
          rec.vx = -rec.vx
        end
      end
      if S.def.modifier == "magnet" and rec.kind == C.YELLOW then
        local pull = (S.bar_x-rec.base_x)/90fx
        rec.base_x = rec.base_x+pull*speed_scale
      end
      local max_x = C.ARENA_W-20fx
      if rec.base_x > max_x then
        rec.base_x = max_x
      end
      if rec.base_x < 20fx then
        rec.base_x = 20fx
      end
      local offset = fmath.sincos(rec.phase)
      rec.y = rec.y-rec.vy*speed_scale
      rec.x = rec.base_x+offset*rec.wob
      W.place(rec.id,rec.x,rec.y)
      if alive(rec.label) then
        W.place(rec.label,rec.x,rec.y+C.SEG_HALF+10fx)
      end
      pewpew.customizable_entity_add_rotation_to_mesh(rec.id,1fx/40fx*speed_scale,0fx,0fx,1fx)
      update_random_visual(rec)
      if rec.y < C.DESPAWN_Y then
        kill_segment(rec)
        compact = true
      end
    end
  end
  if compact then
    local order = {}
    for i = 1,#S.seg_order do
      local id = S.seg_order[i]
      if S.seg[id] ~= nil then
        order[#order+1] = id
      end
    end
    S.seg_order = order
  end
end

function E.collide()
  local compact = false
  for i = 1,#S.seg_order do
    local rec = S.seg[S.seg_order[i]]
    if rec ~= nil and not rec.resolved then
      if bar_hits(rec.x,rec.y,C.SEG_HALF,C.SEG_HALF) then
        E.resolve(rec)
        if S.terminal then
          return
        end
        kill_segment(rec)
        compact = true
      end
    end
  end
  if compact then
    local order = {}
    for i = 1,#S.seg_order do
      local id = S.seg_order[i]
      if S.seg[id] ~= nil then
        order[#order+1] = id
      end
    end
    S.seg_order = order
  end
end

local POP_TYPES = {
  drift = {mesh = 13,color = 0xffa000ff,hp = 1,damage = true},
  warn = {mesh = 13,color = 0xff2b4aff,hp = 1,damage = true},
  chaser = {mesh = 13,color = 0xff3ba0ff,hp = 1,damage = true},
  armored = {mesh = 13,color = 0x8892a6ff,hp = 2,damage = true},
  privacy = {mesh = 13,color = 0x55606eff,hp = 1,damage = true},
  closable = {mesh = 13,color = 0x22d3eeff,hp = 1,damage = true}
}

function E.spawn_popup(x,y,kind)
  if #S.pop_order >= C.MAX_POPUPS then
    return nil
  end
  if E.budget() >= C.MAX_ENTITIES-20 then
    return nil
  end
  local info = POP_TYPES[kind] or POP_TYPES.drift
  local id = W.new(x,y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,info.mesh)
  pewpew.customizable_entity_set_mesh_color(id,info.color)
  W.mesh_scale3(id,7fx/10fx,7fx/10fx,1fx)
  W.vis(id,180fx)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  W.radius(id,42fx)
  pewpew.customizable_entity_start_spawning(id,0)
  local label = W.new(x,y+30fx)
  local text = "WARN"
  if kind == "closable" then
    text = "X CLOSE"
  elseif kind == "armored" then
    text = "LOCK"
  elseif kind == "privacy" then
    text = "PRIVATE"
  elseif kind == "chaser" then
    text = "CLIPPY"
  end
  pewpew.customizable_entity_set_string(label,text)
  W.mesh_scale(label,1fx/2fx)
  pewpew.customizable_entity_set_mesh_color(label,C.PAL.white)
  W.vis(label,180fx)
  local rec = {
    id = id,
    label = label,
    extra = nil,
    kind = kind,
    hp = info.hp,
    x = x,
    y = y,
    vx = 0fx,
    vy = 0fx,
    life = 700,
    damage = info.damage,
    closed = false
  }
  if kind == "drift" then
    rec.vx = fmath.to_fixedpoint(R.int(-3,3))
    rec.vy = -1fx
  elseif kind == "chaser" then
    rec.vy = -1fx
  elseif kind == "warn" then
    rec.vy = 0fx
    rec.life = 420
  elseif kind == "privacy" then
    rec.vy = -1fx/2fx
  elseif kind == "closable" then
    rec.vy = -1fx/2fx
  elseif kind == "armored" then
    rec.vy = -1fx/2fx
  end
  S.pop[id] = rec
  S.pop_order[#S.pop_order+1] = id
  sound(8,x,y)
  return rec
end

function E.close_popup(rec,by_player)
  if rec == nil or rec.closed then
    return
  end
  rec.closed = true
  if alive(rec.id) then
    pewpew.customizable_entity_start_exploding(rec.id,10)
  end
  if alive(rec.label) then
    pewpew.entity_destroy(rec.label)
  end
  S.pop[rec.id] = nil
  if by_player then
    add_score(8)
  end
end

local function update_popups(dt)
  local compact = false
  for i = 1,#S.pop_order do
    local id = S.pop_order[i]
    local rec = S.pop[id]
    if rec == nil then
      compact = true
    elseif not alive(rec.id) then
      if alive(rec.label) then
        pewpew.entity_destroy(rec.label)
      end
      S.pop[id] = nil
      compact = true
    else
      rec.life = rec.life-1
      if rec.kind == "chaser" then
        local dx = S.bar_x-rec.x
        if dx > 30fx then
          rec.vx = 1fx/2fx
        elseif dx < -30fx then
          rec.vx = -1fx/2fx
        else
          rec.vx = 0fx
        end
        if rec.y > S.bar_y+70fx then
          rec.vy = -1fx
        else
          rec.vy = 0fx
        end
      end
      rec.x = rec.x+rec.vx*dt
      rec.y = rec.y+rec.vy*dt
      if rec.x < 60fx then
        rec.x = 60fx
        rec.vx = -rec.vx
      end
      if rec.x > C.ARENA_W-60fx then
        rec.x = C.ARENA_W-60fx
        rec.vx = -rec.vx
      end
      W.place(rec.id,rec.x,rec.y)
      if alive(rec.label) then
        W.place(rec.label,rec.x,rec.y+26fx)
      end
      if S.invuln <= 0 then
        if bar_hits(rec.x,rec.y,46fx,34fx) then
          if rec.kind == "closable" then
            E.close_popup(rec,true)
            message("WINDOW CLOSED")
            sound(13,rec.x,rec.y)
          else
            if S.hooks.crash then
              S.hooks.crash("popup")
            end
          end
        end
      end
      if rec.life <= 0 or rec.y < -60fx then
        E.close_popup(rec,false)
        compact = true
      end
    end
  end
  if compact then
    local order = {}
    for i = 1,#S.pop_order do
      local id = S.pop_order[i]
      if S.pop[id] ~= nil then
        order[#order+1] = id
      end
    end
    S.pop_order = order
  end
end

function E.spawn_shot(x,y,vx,vy,arm)
  if E.budget() >= C.MAX_ENTITIES-20 or #S.shot_order >= C.MAX_SHOTS then
    return nil
  end
  local id = W.new(x,y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,16)
  pewpew.customizable_entity_set_mesh_color(id,C.PAL.red)
  W.vis(id,120fx)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.customizable_entity_start_spawning(id,0)
  local rec = {id = id,x = x,y = y,vx = vx,vy = vy,arm = arm,life = 320}
  S.shot[id] = rec
  S.shot_order[#S.shot_order+1] = id
  sound(8,x,y)
  return rec
end

local function update_shots(dt)
  local compact = false
  for i = 1,#S.shot_order do
    local id = S.shot_order[i]
    local rec = S.shot[id]
    if rec == nil then
      compact = true
    elseif not alive(rec.id) then
      S.shot[id] = nil
      compact = true
    else
      if rec.arm > 0 then
        rec.arm = rec.arm-1
      else
        rec.x = rec.x+rec.vx*dt
        rec.y = rec.y+rec.vy*dt
        W.place(rec.id,rec.x,rec.y)
        rec.life = rec.life-1
        local half_x = rec.half_x or 12fx
        local half_y = rec.half_y or 12fx
        local spent = false
        if S.invuln <= 0 and bar_hits(rec.x,rec.y,half_x,half_y) then
          if consume_firewall(rec.x,rec.y) then
            pewpew.entity_destroy(rec.id)
            S.shot[id] = nil
            spent = true
            compact = true
          elseif S.hooks.crash then
            S.hooks.crash("projectile")
          end
        end
        if not spent and (rec.y < -40fx or rec.y > C.ARENA_H+40fx or rec.x < -40fx or rec.x > C.ARENA_W+40fx or rec.life <= 0) then
          pewpew.entity_destroy(rec.id)
          S.shot[id] = nil
          compact = true
        end
      end
    end
  end
  if compact then
    local order = {}
    for i = 1,#S.shot_order do
      local id = S.shot_order[i]
      if S.shot[id] ~= nil then
        order[#order+1] = id
      end
    end
    S.shot_order = order
  end
end

function E.spawn_scanline()
  if E.budget() >= C.MAX_ENTITIES-20 then
    return
  end
  local y = C.ARENA_H-20fx
  local id = W.new(500fx,y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,17)
  pewpew.customizable_entity_set_mesh_color(id,C.PAL.red)
  W.mesh_scale3(id,5fx,1fx,1fx)
  W.vis(id,520fx)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.customizable_entity_start_spawning(id,0)
  local rec = {id = id,x = 500fx,y = y,vx = 0fx,vy = -7fx,arm = 34,life = 200,half_x = 500fx,half_y = 8fx}
  S.shot[id] = rec
  S.shot_order[#S.shot_order+1] = id
  sound(8,500fx,y)
end

function E.spawn_zone()
  if S.zone_id ~= nil and alive(S.zone_id) then
    pewpew.entity_destroy(S.zone_id)
  end
  local id = W.new(S.zone_x,S.zone_y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,14)
  pewpew.customizable_entity_set_mesh_color(id,C.PAL.dim)
  W.mesh_scale3(id,3fx,2fx,1fx)
  W.vis(id,300fx)
  pewpew.customizable_entity_start_spawning(id,0)
  S.zone_id = id
end

function E.spawn_forced_yellow()
  make_segment(C.YELLOW,fmath.to_fixedpoint(R.int(150,850)),C.SPAWN_Y,0fx,6fx,0fx)
end

local function spawn_one(kind,x,vx,wobble)
  local speed = S.def.speed*S.diff_speed
  if S.boost_timer > 0 then
    speed = speed*7fx/5fx
  end
  return make_segment(kind,x,C.SPAWN_Y,vx,speed,wobble)
end

local function pattern_spawn()
  local def = S.def
  local wobble = def.wobble
  local current = def.current
  local index = S.pattern_step
  S.pattern_step = S.pattern_step+1
  local pattern = def.pattern
  if pattern == "lanes" then
    local lane = index%5+1
    local kind = seg_kind_for_spawn()
    spawn_one(kind,LANES[lane],current,wobble)
  elseif pattern == "pair" then
    local x1 = fmath.to_fixedpoint(R.int(120,880))
    local kind1 = seg_kind_for_spawn()
    spawn_one(kind1,x1,current,wobble)
    if R.chance(60) then
      local x2 = x1+150fx
      if x2 > C.ARENA_W-60fx then
        x2 = x1-150fx
      end
      spawn_one(seg_kind_for_spawn(),x2,current,wobble)
    end
  elseif pattern == "fan" then
    local base = fmath.to_fixedpoint(R.int(300,700))
    for i = -1,1 do
      local kind = seg_kind_for_spawn()
      spawn_one(kind,base+fmath.to_fixedpoint(i)*130fx,current+fmath.to_fixedpoint(i)*8fx,wobble)
    end
  elseif pattern == "columns" then
    local lane = index%3+1
    spawn_one(seg_kind_for_spawn(),LANES[lane*2-1],current,wobble)
  elseif pattern == "chain" then
    local base = fmath.to_fixedpoint(R.int(250,750))
    for i = 0,2 do
      spawn_one(C.YELLOW,base+fmath.to_fixedpoint(i)*70fx,current,wobble)
    end
  elseif pattern == "matrix" then
    local lane = index%5+1
    spawn_one(seg_kind_for_spawn(),LANES[lane],0fx,0fx)
  elseif pattern == "split" then
    local x = fmath.to_fixedpoint(R.int(150,400))
    spawn_one(seg_kind_for_spawn(),x,current,wobble)
    spawn_one(seg_kind_for_spawn(),C.ARENA_W-x,-current,wobble)
  elseif pattern == "choice" then
    local base = fmath.to_fixedpoint(R.int(300,700))
    spawn_one(C.BLUE,base-80fx,current,wobble)
    spawn_one(C.YELLOW,base+80fx,current,wobble)
  elseif pattern == "sequence" then
    local order = S.seq
    if #order == 0 then
      order = {3,1,5,2,4}
      S.seq = order
    end
    local lane = order[index%#order+1]
    spawn_one(seg_kind_for_spawn(),LANES[lane],0fx,0fx)
  else
    local x = fmath.to_fixedpoint(R.int(140,860))
    spawn_one(seg_kind_for_spawn(),x,current,wobble)
  end
end

local function popup_kind()
  local modifier = S.def.modifier
  if modifier == "privacy" or modifier == "combo_popup_aim" then
    if R.chance(40) then
      return "privacy"
    end
    return "drift"
  end
  if modifier == "closable" then
    return "closable"
  end
  if modifier == "armor" then
    return "armored"
  end
  if modifier == "combo_popup_aim" or modifier == "triad" then
    if R.chance(30) then
      return "chaser"
    end
    return "drift"
  end
  if R.chance(25) then
    return "warn"
  end
  return "drift"
end

local function update_modifiers(dt)
  local modifier = S.def.modifier
  S.mod_timer = S.mod_timer+1
  if modifier == "freeze" then
    if S.freeze_timer > 0 then
      S.freeze_timer = S.freeze_timer-1
    elseif S.mod_timer%260 == 0 then
      S.freeze_timer = 60
      message("SYSTEM FREEZE")
      sound(8,500fx,400fx)
    end
  elseif modifier == "overclock_cycle" then
    if S.boost_timer > 0 then
      S.boost_timer = S.boost_timer-1
    elseif S.mod_timer%240 == 0 then
      S.boost_timer = 90
      message("OVERCLOCK CYCLE")
      sound(9,500fx,400fx)
    end
  elseif modifier == "conveyor" then
    if S.mod_timer%240 == 0 then
      S.def.current = -S.def.current
      message("BELT REVERSED")
      sound(8,500fx,400fx)
    end
  elseif modifier == "zone" then
    if S.zone_id == nil then
      E.spawn_zone()
    end
    S.zone_x = 500fx+fmath.sincos(fmath.from_fraction(S.mod_timer,60))*260fx
    S.zone_y = 500fx+fmath.sincos(fmath.from_fraction(S.mod_timer,90))*80fx
    if S.zone_id ~= nil and alive(S.zone_id) then
      W.place(S.zone_id,S.zone_x,S.zone_y)
    end
    if S.mod_timer%180 == 0 then
      E.spawn_scanline()
      message("SWEEP INCOMING")
    end
  elseif modifier == "scanline" or modifier == "combo_scanline_lanes" or modifier == "triad_two" then
    if S.mod_timer%190 == 0 then
      E.spawn_scanline()
      message("SCANLINE")
    end
  elseif modifier == "combo_popup_aim" then
    if S.mod_timer%220 == 0 then
      local x = fmath.to_fixedpoint(R.int(150,850))
      E.spawn_shot(x,C.ARENA_H-30fx,0fx,-6fx,30)
      message("AIMED PACKET")
    end
  end
  if modifier == "sequence" then
    if S.seq_show > 0 then
      S.seq_show = S.seq_show-1
    elseif S.mod_timer%420 == 1 then
      S.seq_show = 90
      message("MEMORISE: 3 1 5 2 4")
    end
  end
  if dt < 1fx then
    return
  end
end

function E.update(dt)
  S.level_tick = S.level_tick+1
  if S.combo_count > 0 then
    S.combo_timer = S.combo_timer+1
    if S.combo_timer >= C.COMBO_DECAY then
      combo_reset()
      message("COMBO LOST")
    end
  end
  update_modifiers(dt)
  update_segments(dt)
  update_popups(dt)
  update_shots(dt)
  B.update(dt)
end

function E.spawn_tick(dt)
  local def = S.def
  local interval = def.interval
  local density = S.diff_density
  S.spawn_acc = S.spawn_acc+dt
  if S.spawn_acc >= fmath.to_fixedpoint(interval)*density then
    S.spawn_acc = 0fx
    S.spawn_attempts = S.spawn_attempts+1
    pattern_spawn()
  end
  if def.popup_rate > 0 then
    S.popup_acc = S.popup_acc+dt
    if S.popup_acc >= fmath.to_fixedpoint(def.popup_rate)*density then
      S.popup_acc = 0fx
      local x = fmath.to_fixedpoint(R.int(160,840))
      E.spawn_popup(x,640fx,popup_kind())
    end
  end
end

function E.scan(x,y)
  local removed = 0
  local radius = C.SCAN_RADIUS
  for i = #S.pop_order,1,-1 do
    local rec = S.pop[S.pop_order[i]]
    if rec ~= nil then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius then
        rec.hp = rec.hp-1
        if rec.hp <= 0 then
          E.close_popup(rec,true)
          removed = removed+1
        else
          message("ARMOR CRACKED")
        end
      end
    end
  end
  for i = 1,#S.seg_order do
    local rec = S.seg[S.seg_order[i]]
    if rec ~= nil and rec.kind == C.RED then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius then
        rec.kind = C.GRAY
        pewpew.customizable_entity_set_mesh(rec.id,C.MESH,C.SEG[C.GRAY].mesh)
        pewpew.customizable_entity_set_mesh_color(rec.id,C.SEG[C.GRAY].color)
        if alive(rec.label) then
          pewpew.customizable_entity_set_string(rec.label,C.SEG[C.GRAY].symbol)
        end
        if S.red_live > 0 then
          S.red_live = S.red_live-1
        end
        removed = removed+1
      end
    end
    if rec ~= nil and rec.decoy then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius then
        rec.decoy = false
        pewpew.customizable_entity_set_mesh_color(rec.id,C.SEG[rec.kind].color)
        message("DECOY EXPOSED")
      end
    end
  end
  for i = #S.shot_order,1,-1 do
    local rec = S.shot[S.shot_order[i]]
    if rec ~= nil then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius then
        if alive(rec.id) then
          pewpew.entity_destroy(rec.id)
        end
        S.shot[rec.id] = nil
        removed = removed+1
      end
    end
  end
  B.on_scan(x,y)
  W.explode(x,y,C.PAL.cyan,3fx,30)
  sound(16,x,y)
  return removed
end

function E.defrag()
  local removed = P.clear_corrupt()
  S.screen_dirty = true
  if removed > 0 then
    add_score(removed*15)
    message("DEFRAGMENTED")
    W.explode(S.bar_x,S.bar_y,C.PAL.gold,2fx,24)
    sound(7,S.bar_x,S.bar_y)
    B.defrag_opened()
  else
    message("NOTHING TO DEFRAG")
    sound(14,S.bar_x,S.bar_y)
  end
  return removed
end

function E.pink_at_zero_check()
  if P.filled() == 0 then
    return true
  end
  return false
end

function E.crash_cleanup(x,y)
  local radius = 230fx
  for i = 1,#S.seg_order do
    local rec = S.seg[S.seg_order[i]]
    if rec ~= nil then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius and (rec.kind == C.RED or rec.kind == C.RANDOM or rec.kind == C.PINK) then
        kill_segment(rec)
      end
    end
  end
  for i = #S.pop_order,1,-1 do
    local rec = S.pop[S.pop_order[i]]
    if rec ~= nil then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius then
        E.close_popup(rec,false)
      end
    end
  end
  for i = #S.shot_order,1,-1 do
    local rec = S.shot[S.shot_order[i]]
    if rec ~= nil then
      local dx = rec.x-x
      local dy = rec.y-y
      if dx*dx+dy*dy < radius*radius then
        if alive(rec.id) then
          pewpew.entity_destroy(rec.id)
        end
        S.shot[rec.id] = nil
      end
    end
  end
end

function E.level_reset(def)
  E.clear_all()
  S.def = def
  S.seg = {}
  S.seg_order = {}
  S.pop = {}
  S.pop_order = {}
  S.shot = {}
  S.shot_order = {}
  bag.reset(def)
  S.spawn_acc = 0fx
  S.popup_acc = 0fx
  S.pattern_step = 0
  S.spawn_pity = 0
  S.spawn_attempts = 0
  S.red_live = 0
  S.cyan_live = 0
  S.green_spawned = 0
  S.green_used = false
  S.freeze_timer = 0
  S.boost_timer = 0
  S.mod_timer = 0
  S.mod_phase = 0
  S.seq_show = 0
  S.seq_index = 0
  S.seq = {}
  S.zone_x = 500fx
  S.zone_y = 520fx
  S.zone_id = nil
  S.boss_corrupt = false
  S.pending_complete = false
  S.yellow_taken = 0
  S.blue_taken = 0
  S.gray_at_zero = 0
  S.pink_at_zero = 0
  S.damage = 0
  S.crash_count = 0
  S.charges_used = 0
  S.firewall_uses = 0
  S.scan_uses = 0
  S.firewall_timer = 0
  S.slow_timer = 0
  S.time_scale = 1fx
  S.invuln = 0
  S.level_tick = 0
  S.terminal = false
  P.reset()
  if def.boss ~= nil then
    B.start(def.boss)
  end
end

B.attach(E)

return E
