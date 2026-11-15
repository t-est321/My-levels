local C = require("/dynamic/game_config.lua")
local S = require("/dynamic/state.lua")
local R = require("/dynamic/rng.lua")
local W = require("/dynamic/world.lua")

local B = {}

local E = nil

local PHASES = {
  CLIPPY = 3,
  STORM = 3,
  DEFRAG = 3,
  KERNEL = 4
}

local THRESHOLDS = {
  CLIPPY = {30,62},
  STORM = {30,62},
  DEFRAG = {30,62},
  KERNEL = {25,50,75}
}

local NAMES = {
  CLIPPY = "CLIPPY.EXE",
  STORM = "POPUP.STORM",
  DEFRAG = "DEFRAGMENTOR",
  KERNEL = "KERNEL.BSOD"
}

local function sound(index,x,y)
  pewpew.play_sound(C.SOUND,index,x,y)
end

local function message(text)
  if S.hooks.message then
    S.hooks.message(text)
  end
end

local function new_entity(x,y,mesh,color,scale_x,scale_y,radius)
  local id = W.new(x,y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,mesh)
  pewpew.customizable_entity_set_mesh_color(id,color)
  if scale_x ~= nil then
    W.mesh_scale3(id,scale_x,scale_y or scale_x,1fx)
  end
  W.vis(id,radius or 260fx)
  pewpew.customizable_entity_set_position_interpolation(id,true)
  pewpew.customizable_entity_start_spawning(id,0)
  return id
end

local function kill(id)
  if id ~= nil and pewpew.entity_get_is_alive(id) then
    pewpew.customizable_entity_start_exploding(id,12)
  end
end

local function clear_parts()
  local boss = S.boss
  if boss == nil then
    return
  end
  for i = 1,#boss.parts do
    kill(boss.parts[i])
  end
  boss.parts = {}
end

local function add_part(id)
  local boss = S.boss
  if boss ~= nil then
    boss.parts[#boss.parts+1] = id
  end
end

local function alive(id)
  return id ~= nil and pewpew.entity_get_is_alive(id)
end

function B.attach(entities)
  E = entities
end

function B.start(kind)
  local boss = {
    kind = kind,
    name = NAMES[kind] or "HOSTILE",
    phase = 1,
    phase_count = PHASES[kind] or 3,
    timer = 0,
    phase_timer = 0,
    total_timer = 0,
    parts = {},
    shots = {},
    walls = {},
    done = false,
    stun = 0,
    wave = 0,
    wave_timer = 0,
    gap_open = 0,
    body = nil,
    core = nil,
    ring_a = nil,
    ring_b = nil,
    angle = 0,
    x = 500fx,
    y = 600fx
  }
  S.boss = boss
  if kind == "CLIPPY" then
    boss.body = new_entity(500fx,600fx,18,0xffa000ff,1fx,1fx,300fx)
    add_part(boss.body)
  elseif kind == "STORM" then
    boss.body = new_entity(500fx,620fx,20,0xff3ba0ff,1fx/2fx,1fx/2fx,300fx)
    add_part(boss.body)
  elseif kind == "DEFRAG" then
    boss.ring_a = new_entity(500fx,520fx,19,0xffc400ff,1fx,1fx,320fx)
    boss.ring_b = new_entity(500fx,520fx,19,0x8892a6ff,3fx/4fx,3fx/4fx,320fx)
    boss.core = new_entity(500fx,520fx,20,0x22d3eeff,1fx/2fx,1fx/2fx,300fx)
    add_part(boss.ring_a)
    add_part(boss.ring_b)
    add_part(boss.core)
  elseif kind == "KERNEL" then
    boss.core = new_entity(500fx,600fx,20,0xff2b4aff,3fx/4fx,3fx/4fx,320fx)
    boss.ring_a = new_entity(500fx,600fx,19,0x22d3eeff,1fx/2fx,1fx/2fx,320fx)
    add_part(boss.core)
    add_part(boss.ring_a)
  end
  message(boss.name.." ONLINE")
  sound(9,500fx,600fx)
  W.explode(500fx,600fx,0xff2b4aff,2fx,30)
end

local function clear_shots()
  local boss = S.boss
  if boss == nil then
    return
  end
  for i = 1,#boss.shots do
    kill(boss.shots[i].id)
  end
  boss.shots = {}
end

local function clear_walls()
  local boss = S.boss
  if boss == nil then
    return
  end
  for i = 1,#boss.walls do
    local wall = boss.walls[i]
    if wall ~= nil then
      kill(wall.left)
      kill(wall.right)
    end
    boss.walls[i] = nil
  end
  boss.walls = {}
end

function B.clear()
  local boss = S.boss
  if boss ~= nil then
    clear_shots()
    clear_walls()
    clear_parts()
  end
  S.boss = nil
  S.boss_corrupt = false
  S.boss_scan_stun = 0
end

function B.done()
  local boss = S.boss
  return boss == nil or boss.done
end

function B.phase()
  local boss = S.boss
  if boss == nil then
    return 0
  end
  return boss.phase
end

local function spawn_shot(x,y,target_x,target_y,speed,arm)
  local boss = S.boss
  if boss == nil or E == nil then
    return
  end
  if E.budget() >= C.MAX_ENTITIES-10 then
    return
  end
  local dx = target_x-x
  local dy = target_y-y
  local length = fmath.sqrt(dx*dx+dy*dy)
  if length < 1fx then
    length = 1fx
  end
  local id = new_entity(x,y,16,0xff2b4aff,1fx,1fx,120fx)
  W.radius(id,10fx)
  local shot = {
    id = id,
    x = x,
    y = y,
    vx = dx/length*speed,
    vy = dy/length*speed,
    arm = arm,
    life = 260
  }
  boss.shots[#boss.shots+1] = shot
  sound(8,x,y)
end

local function spawn_wall(y,gap_center,gap_width)
  local boss = S.boss
  if boss == nil then
    return
  end
  if gap_width < 520fx then
    gap_width = 520fx
  end
  local left_edge = gap_center-gap_width/2fx
  local right_edge = gap_center+gap_width/2fx
  if left_edge < 0fx then
    left_edge = 0fx
  end
  if right_edge > C.ARENA_W then
    right_edge = C.ARENA_W
  end
  local left_width = left_edge
  local right_width = C.ARENA_W-right_edge
  local wall = {left = nil,right = nil,y = y,speed = 2fx,live = true,left_width = left_width,right_width = right_width,right_x = (right_edge+C.ARENA_W)/2fx}
  if left_width > 30fx then
    wall.left = new_entity(left_width/2fx,y,14,0xffa000ff,left_width/120fx,1fx,320fx)
  else
    wall.left_width = 0fx
  end
  if right_width > 30fx then
    wall.right = new_entity(wall.right_x,y,14,0xffa000ff,right_width/120fx,1fx,320fx)
  else
    wall.right_width = 0fx
  end
  boss.walls[#boss.walls+1] = wall
  sound(8,gap_center,y)
end

local function spawn_lane_warning(lane,y)
  local x = 100fx+fmath.to_fixedpoint(lane-1)*200fx
  local id = new_entity(x,y,15,0xff2b4aff,1fx,1fx,140fx)
  local boss = S.boss
  boss.shots[#boss.shots+1] = {
    id = id,
    x = x,
    y = y,
    vx = 0fx,
    vy = -6fx,
    arm = 34,
    life = 200
  }
end

local function warn_bar(target)
  local x = S.bar_x
  local y = S.bar_y
  local id = new_entity(x,y,15,0xff2b4aff,1fx,1fx,140fx)
  local boss = S.boss
  boss.shots[#boss.shots+1] = {
    id = id,
    x = x,
    y = y,
    vx = 0fx,
    vy = 0fx,
    arm = target,
    life = 200,
    marker = true
  }
end

local function advance_phase()
  local boss = S.boss
  if boss == nil then
    return
  end
  clear_shots()
  clear_walls()
  boss.phase = boss.phase+1
  boss.phase_timer = 0
  boss.timer = 0
  boss.wave = 0
  boss.wave_timer = 0
  if boss.phase > boss.phase_count then
    boss.phase = boss.phase_count
    boss.done = true
    message(boss.name.." PURGED")
    sound(10,500fx,400fx)
    W.explode(500fx,450fx,0x33ff88ff,4fx,60)
    return
  end
  message("PHASE "..tostring(boss.phase).." ENGAGED")
  sound(9,500fx,500fx)
  W.explode(boss.x,boss.y,0xffc400ff,2fx,26)
end

function B.on_scan(x,y)
  local boss = S.boss
  if boss == nil then
    return false
  end
  local dx = boss.x-x
  local dy = boss.y-y
  if dx*dx+dy*dy > 320fx*320fx then
    return false
  end
  if boss.kind == "CLIPPY" then
    boss.stun = 120
    boss.y = 620fx
    W.place(boss.body,500fx,620fx)
    boss.x = 500fx
  elseif boss.kind == "DEFRAG" then
    boss.stun = 70
  else
    boss.stun = 60
  end
  message("SCAN STUN")
  return true
end

function B.defrag_opened()
  local boss = S.boss
  if boss == nil then
    return false
  end
  if boss.kind == "DEFRAG" or boss.kind == "KERNEL" then
    boss.gap_open = 200
    S.boss_corrupt = false
    message("DEFRAG WINDOW OPEN")
    return true
  end
  return false
end

local function update_shots(dt)
  local boss = S.boss
  for i = #boss.shots,1,-1 do
    local shot = boss.shots[i]
    if not alive(shot.id) then
      table.remove(boss.shots,i)
    else
      if shot.arm > 0 then
        local ticks = 1
        if dt < 1fx then
          ticks = 1
        end
        shot.arm = shot.arm-ticks
        if shot.arm <= 0 and not shot.marker then
          pewpew.customizable_entity_set_mesh(shot.id,C.MESH,16)
        end
      else
        shot.x = shot.x+shot.vx*dt
        shot.y = shot.y+shot.vy*dt
        W.place(shot.id,shot.x,shot.y)
        shot.life = shot.life-1
        local spent = false
        if S.invuln <= 0 and shot.marker == nil then
          local dx = shot.x-S.bar_x
          local dy = shot.y-S.bar_y
          if dx > -C.BAR_HW-10fx and dx < C.BAR_HW+10fx and dy > -C.BAR_HH-10fx and dy < C.BAR_HH+10fx then
            if S.firewall_timer > 0 then
              S.firewall_timer = 0
              S.firewall_uses = S.firewall_uses+1
              message("FIREWALL BLOCK")
              sound(15,shot.x,shot.y)
            else
              message("HIT BY "..boss.name)
              S.hooks.crash("boss shot")
            end
            spent = true
          end
        end
        if spent or shot.y < -40fx or shot.x < -40fx or shot.x > C.ARENA_W+40fx or shot.life <= 0 then
          pewpew.entity_destroy(shot.id)
          table.remove(boss.shots,i)
          if S.terminal then
            return
          end
        end
      end
    end
  end
end

local function wall_hits(x,width,y)
  if width <= 0fx then
    return false
  end
  if y+18fx < S.bar_y-C.BAR_HH or y-18fx > S.bar_y+C.BAR_HH then
    return false
  end
  if x+width/2fx < S.bar_x-C.BAR_HW or x-width/2fx > S.bar_x+C.BAR_HW then
    return false
  end
  return true
end

local function update_walls(dt)
  local boss = S.boss
  for i = #boss.walls,1,-1 do
    local wall = boss.walls[i]
    wall.y = wall.y-wall.speed*dt
    if wall.left ~= nil and pewpew.entity_get_is_alive(wall.left) then
      W.place(wall.left,wall.left_width/2fx,wall.y)
    end
    if wall.right ~= nil and pewpew.entity_get_is_alive(wall.right) then
      W.place(wall.right,wall.right_x,wall.y)
    end
    if S.invuln <= 0 then
      if wall_hits(wall.left_width/2fx,wall.left_width,wall.y) then
        S.hooks.crash("popup wall")
      end
      if wall_hits(wall.right_x,wall.right_width,wall.y) then
        S.hooks.crash("popup wall")
      end
    end
    local left_gone = wall.left == nil or not pewpew.entity_get_is_alive(wall.left)
    local right_gone = wall.right == nil or not pewpew.entity_get_is_alive(wall.right)
    if (left_gone and right_gone) or wall.y < -60fx then
      kill(wall.left)
      kill(wall.right)
      table.remove(boss.walls,i)
    end
  end
end

local function clippy_phase(dt)
  local boss = S.boss
  boss.timer = boss.timer+1
  if boss.stun > 0 then
    boss.stun = boss.stun-1
    return
  end
  if boss.phase == 1 then
    local wave = select(1,fmath.sincos(fmath.from_fraction(boss.timer,40)))
    W.place(boss.body,500fx+wave*300fx,600fx)
    if boss.timer%55 == 0 then
      spawn_shot(500fx,560fx,S.bar_x,S.bar_y,5fx,32)
    end
  elseif boss.phase == 2 then
    if boss.timer%100 == 0 and #boss.walls < 2 then
      local gap = R.int(300,700)
      spawn_wall(690fx,fmath.to_fixedpoint(gap),540fx)
    end
  else
    local dx = S.bar_x-boss.x
    local step = dx/40fx
    if step > 4fx then
      step = 4fx
    end
    if step < -4fx then
      step = -4fx
    end
    boss.x = boss.x+step*dt
    boss.y = boss.y-1fx*dt
    if boss.y < 480fx then
      boss.y = 480fx
    end
    W.place(boss.body,boss.x,boss.y)
    if boss.timer%90 == 0 then
      warn_bar(26)
      spawn_shot(boss.x,boss.y,S.bar_x,S.bar_y,6fx,26)
    end
  end
end

local function storm_phase(dt)
  local boss = S.boss
  boss.timer = boss.timer+1
  boss.phase_timer = boss.phase_timer+1
  local wave_length = 220
  if boss.phase_timer > wave_length then
    advance_phase()
    return
  end
  if boss.phase == 1 then
    if boss.timer%70 == 0 and E ~= nil then
      E.spawn_popup(fmath.to_fixedpoint(R.int(120,880)),690fx,"drift")
    end
  elseif boss.phase == 2 then
    if boss.timer%90 == 0 and E ~= nil then
      E.spawn_popup(fmath.to_fixedpoint(R.int(200,800)),fmath.to_fixedpoint(R.int(420,660)),"warn")
    end
    if boss.timer%140 == 0 and #boss.walls < 2 then
      spawn_wall(700fx,fmath.to_fixedpoint(R.int(320,680)),620fx)
    end
  else
    if boss.timer%60 == 0 and E ~= nil then
      E.spawn_popup(400fx+fmath.to_fixedpoint(R.int(-1,1))*220fx,470fx,"closable")
    end
  end
end

local function defrag_phase(dt)
  local boss = S.boss
  boss.timer = boss.timer+1
  boss.phase_timer = boss.phase_timer+1
  boss.angle = boss.angle+1fx/25fx*dt
  if boss.ring_a ~= nil and alive(boss.ring_a) then
    pewpew.customizable_entity_add_rotation_to_mesh(boss.ring_a,1fx/25fx*dt,0fx,0fx,1fx)
  end
  if boss.ring_b ~= nil and alive(boss.ring_b) then
    pewpew.customizable_entity_add_rotation_to_mesh(boss.ring_b,-2fx/25fx*dt,0fx,0fx,1fx)
  end
  if boss.stun > 0 then
    boss.stun = boss.stun-1
  end
  if boss.gap_open > 0 then
    boss.gap_open = boss.gap_open-1
    S.boss_corrupt = false
  else
    S.boss_corrupt = boss.phase >= 2
  end
  if boss.phase == 1 then
    if boss.phase_timer > 300 then
      advance_phase()
    end
  elseif boss.phase == 2 then
    if boss.phase_timer > 300 then
      advance_phase()
    end
    if not S.boss_corrupt and S.charges.defrag <= 0 and boss.timer%120 == 0 then
      S.charges.defrag = 1
      message("EMERGENCY DEFRAG GRANTED")
    end
  else
    if boss.phase_timer > 240 and boss.gap_open == 0 then
      advance_phase()
    end
  end
  if S.invuln <= 0 and (boss.phase == 2 or boss.phase == 3) and boss.gap_open == 0 then
    local dx = S.bar_x-500fx
    local dy = S.bar_y-520fx
    local dist = fmath.sqrt(dx*dx+dy*dy)
    if dist < 78fx then
      S.hooks.crash("ring")
    end
  end
end

local function kernel_phase(dt)
  local boss = S.boss
  boss.timer = boss.timer+1
  boss.phase_timer = boss.phase_timer+1
  if boss.ring_a ~= nil and alive(boss.ring_a) then
    pewpew.customizable_entity_add_rotation_to_mesh(boss.ring_a,1fx/20fx*dt,0fx,0fx,1fx)
  end
  local length = 260
  if boss.phase == 4 then
    length = 300
  end
  if boss.phase_timer > length then
    advance_phase()
    return
  end
  if boss.phase == 1 then
    if boss.timer%50 == 0 then
      spawn_shot(500fx,560fx,S.bar_x,S.bar_y,6fx,30)
    end
    if boss.timer%80 == 0 then
      spawn_lane_warning(R.int(1,5),700fx)
    end
  elseif boss.phase == 2 then
    if boss.timer%110 == 0 and #boss.walls < 2 then
      spawn_wall(700fx,fmath.to_fixedpoint(R.int(340,660)),620fx)
    end
  elseif boss.phase == 3 then
    if S.charges.defrag <= 0 and boss.timer%100 == 0 then
      S.charges.defrag = 1
      message("DEFRAG RESUPPLY")
    end
    if boss.timer%55 == 0 and E ~= nil then
      E.spawn_forced_yellow()
    end
  else
    if boss.timer%40 == 0 then
      spawn_shot(500fx,580fx,S.bar_x,S.bar_y,7fx,24)
    end
    if boss.timer%120 == 0 then
      spawn_wall(700fx,fmath.to_fixedpoint(R.int(300,700)),620fx)
    end
  end
end

function B.update(dt)
  local boss = S.boss
  if boss == nil or boss.done then
    return
  end
  boss.total_timer = boss.total_timer+1
  boss.phase_timer = boss.phase_timer+1
  local filled = S.hooks.filled_percent()
  local thresholds = THRESHOLDS[boss.kind] or {30,62}
  local wanted = 1
  for i = 1,#thresholds do
    if filled >= thresholds[i] then
      wanted = i+1
    end
  end
  if wanted > boss.phase then
    boss.phase = wanted-1
    advance_phase()
    return
  end
  local fallback = 900
  if boss.phase_timer > fallback then
    advance_phase()
    return
  end
  if boss.kind == "CLIPPY" then
    clippy_phase(dt)
  elseif boss.kind == "STORM" then
    storm_phase(dt)
  elseif boss.kind == "DEFRAG" then
    defrag_phase(dt)
  elseif boss.kind == "KERNEL" then
    kernel_phase(dt)
  end
  update_shots(dt)
  update_walls(dt)
end

return B
