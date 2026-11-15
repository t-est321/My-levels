local C = require("/dynamic/game_config.lua")
local S = require("/dynamic/state.lua")
local P = require("/dynamic/progress.lua")
local W = require("/dynamic/world.lua")

local I = {}

local backdrop = {}
local hud = {}
local home = {}
local screen = {}
local last_text = {}
local hidden = true
local boom_timer = 0
local boom_count = 0

local T_TITLE = 2fx
local T_SUB = 1fx
local T_BODY = 4fx/5fx
local T_SMALL = 3fx/5fx
local T_MENU = 1fx

local function remember(id,x,y)
  home[id] = {x,y}
  return id
end

local function entity(x,y,mesh,color,scale,radius)
  local id = W.new(x,y)
  pewpew.customizable_entity_set_mesh(id,C.MESH,mesh)
  pewpew.customizable_entity_set_mesh_color(id,color)
  if scale ~= nil then
    W.mesh_scale(id,scale)
  end
  W.vis(id,radius or 900fx)
  pewpew.customizable_entity_start_spawning(id,0)
  return remember(id,x,y)
end

local function text(x,y,value,scale,color,radius)
  local id = W.new(x,y)
  pewpew.customizable_entity_set_string(id,value)
  W.mesh_scale(id,scale or 1fx)
  pewpew.customizable_entity_set_mesh_color(id,color or C.PAL.white)
  W.vis(id,radius or 900fx)
  last_text[id] = value
  return remember(id,x,y)
end

local function set_text(id,value)
  if id == nil then
    return
  end
  if last_text[id] == value then
    return
  end
  last_text[id] = value
  pewpew.customizable_entity_set_string(id,value)
end

local function set_color(id,color)
  if id ~= nil and pewpew.entity_get_is_alive(id) then
    pewpew.customizable_entity_set_mesh_color(id,color)
  end
end

local function destroy_list(list)
  for i = 1,#list do
    if list[i] ~= nil and pewpew.entity_get_is_alive(list[i]) then
      pewpew.entity_destroy(list[i])
    end
    last_text[list[i]] = nil
  end
  return {}
end

local function wrap(value,max_chars)
  local lines = {}
  local current = ""
  for word in string.gmatch(value,"%S+") do
    if #current == 0 then
      current = word
    elseif #current+1+#word <= max_chars then
      current = current.." "..word
    else
      lines[#lines+1] = current
      current = word
    end
  end
  if #current > 0 then
    lines[#lines+1] = current
  end
  if #lines == 0 then
    lines[1] = ""
  end
  return lines
end

function I.init()
  backdrop = {}
  hud = {}
  home = {}
  backdrop[#backdrop+1] = entity(500fx,350fx,32,0x0a1424ff,1fx,900fx)
  backdrop[#backdrop+1] = entity(500fx,350fx,33,0x102238ff,1fx,900fx)
  backdrop[#backdrop+1] = entity(500fx,350fx,34,0x0b1a2aff,1fx,900fx)
  backdrop[#backdrop+1] = entity(500fx,350fx,35,0x142c46ff,1fx,900fx)
  backdrop[#backdrop+1] = entity(500fx,350fx,36,0x132740ff,1fx,900fx)
  hud.taskbar = entity(500fx,C.HUD_PAD_Y,27,0x1a2c44ff,1fx,900fx)
  hud.bar = entity(S.bar_x,S.bar_y,12,C.PAL.border,1fx,600fx)
  pewpew.customizable_entity_set_position_interpolation(hud.bar,true)
  hud.cells = {}
  for i = 1,C.CELLS do
    local id = entity(S.bar_x,S.bar_y,38,C.PAL.dim,1fx,600fx)
    pewpew.customizable_entity_set_position_interpolation(id,true)
    hud.cells[i] = id
  end
  hud.icons = {}
  hud.counts = {}
  for i = 1,4 do
    local x = 620fx+fmath.to_fixedpoint(i-1)*45fx
    hud.icons[i] = entity(x,40fx,C.UTIL[i].icon,C.PAL.dim,1fx,220fx)
    hud.counts[i] = text(x+20fx,40fx,"0",T_SMALL,C.PAL.white,220fx)
  end
  hud.hearts = {}
  for i = 1,3 do
    hud.hearts[i] = entity(C.HUD_PAD_X+fmath.to_fixedpoint(i-1)*32fx,40fx,25,C.PAL.dim,1fx,220fx)
  end
  hud.info_text = text(500fx,88fx,"",T_BODY,C.PAL.hud,700fx)
  hud.status_text = text(500fx,64fx,"",T_SMALL,C.PAL.white,700fx)
  hud.boss_text = text(500fx,40fx,"",T_SMALL,C.PAL.gold,700fx)
  hud.combo_text = text(500fx,145fx,"",T_SUB,C.PAL.amber,700fx)
  pewpew.configure_player_hud(0,{top_left_line = ""})
  I.hide_world()
end

local BG_PLAY = {0x0a1424ff,0x102238ff,0x0b1a2aff,0x142c46ff,0x132740ff}
local BG_MENU = {0x08101cff,0x0b1826ff,0x081420ff,0x0c1c2cff,0x0a1826ff}

local function paint_bg(mode)
  local pal = BG_PLAY
  if mode == 2 then
    pal = BG_MENU
  end
  for i = 1,#backdrop do
    set_color(backdrop[i],pal[i])
  end
end

local function hud_list()
  local list = {hud.taskbar,hud.bar,hud.info_text,hud.status_text,hud.boss_text,hud.combo_text}
  for i = 1,#hud.cells do
    list[#list+1] = hud.cells[i]
  end
  for i = 1,#hud.icons do
    list[#list+1] = hud.icons[i]
    list[#list+1] = hud.counts[i]
  end
  for i = 1,#hud.hearts do
    list[#list+1] = hud.hearts[i]
  end
  return list
end

function I.hide_world()
  hidden = true
  paint_bg(2)
  local list = hud_list()
  for i = 1,#list do
    local id = list[i]
    if id ~= nil and pewpew.entity_get_is_alive(id) then
      W.place(id,500fx,-4000fx)
    end
  end
end

function I.show_world()
  hidden = false
  paint_bg(1)
  local list = hud_list()
  for i = 1,#list do
    local id = list[i]
    if id ~= nil and pewpew.entity_get_is_alive(id) and home[id] ~= nil then
      W.place(id,home[id][1],home[id][2])
    end
  end
end

function I.gameplay_visible()
  return not hidden
end

function I.move_cells()
  local left = S.bar_x-C.BAR_HW+C.CELL_W/2fx
  for i = 1,C.CELLS do
    local x = left+fmath.to_fixedpoint(i-1)*C.CELL_W
    W.place(hud.cells[i],x,S.bar_y)
  end
end

function I.draw_cells()
  for i = 1,C.CELLS do
    local id = hud.cells[i]
    local cell = S.cells[i]
    if cell == 1 then
      pewpew.customizable_entity_set_mesh(id,C.MESH,37)
      set_color(id,C.SEG[C.BLUE].color)
    elseif cell == 2 then
      pewpew.customizable_entity_set_mesh(id,C.MESH,39)
      set_color(id,C.SEG[C.YELLOW].color)
    else
      pewpew.customizable_entity_set_mesh(id,C.MESH,38)
      set_color(id,C.PAL.dim)
    end
  end
end

function I.update()
  if hidden then
    return
  end
  W.place(hud.bar,S.bar_x,S.bar_y)
  I.move_cells()
  if S.screen_dirty then
    I.draw_cells()
    S.screen_dirty = false
  end
  local title = ""
  if S.def ~= nil then
    title = S.def.title
  end
  set_text(hud.info_text,"LV "..tostring(S.level).."  "..title.."   SCORE "..tostring(pewpew.get_score_of_player(0)))
  set_text(hud.status_text,"BAR "..tostring(P.percent()).."%   CLEAN "..tostring(P.correct_percent()).."%   "..S.difficulty)
  local status = ""
  if S.def ~= nil and S.def.boss ~= nil and S.boss ~= nil then
    if S.boss.done then
      status = "BOSS PURGED - FILL THE BAR"
    else
      status = S.boss.name.."  PHASE "..tostring(S.boss.phase).."/"..tostring(S.boss.phase_count)
    end
  else
    if S.firewall_timer > 0 then
      status = status.."FIREWALL "..tostring(S.firewall_timer).."  "
    end
    if S.slow_timer > 0 then
      status = status.."SLOW "..tostring(S.slow_timer).."  "
    end
    if S.invuln > 0 then
      status = status.."SHIELD "..tostring(S.invuln)
    end
  end
  set_text(hud.boss_text,status)
  if S.combo_count > 0 then
    local mult = 1
    if S.combo_count >= 20 then
      mult = 3
    elseif S.combo_count >= 15 then
      mult = 2
    elseif S.combo_count >= 10 then
      mult = 2
    elseif S.combo_count >= 5 then
      mult = 1
    end
    if mult > 1 then
      set_text(hud.combo_text,"COMBO "..tostring(S.combo_count).."  x"..tostring(mult))
    else
      set_text(hud.combo_text,"COMBO "..tostring(S.combo_count))
    end
  else
    set_text(hud.combo_text,"")
  end
  local keys = {"scan","firewall","defrag","slow"}
  for i = 1,4 do
    local count = S.charges[keys[i]]
    set_text(hud.counts[i],tostring(count))
    if count > 0 then
      set_color(hud.icons[i],C.UTIL[i].color)
      set_color(hud.counts[i],C.PAL.white)
    else
      set_color(hud.icons[i],C.PAL.locked)
      set_color(hud.counts[i],C.PAL.locked)
    end
  end
  for i = 1,3 do
    if i <= S.lives then
      set_color(hud.hearts[i],C.PAL.pink)
    else
      set_color(hud.hearts[i],C.PAL.locked)
    end
  end
  if boom_timer > 0 then
    boom_timer = boom_timer-1
  end
end

function I.message(value)
  if boom_timer > 0 and boom_count > 2 then
    return
  end
  boom_timer = 18
  boom_count = boom_count+1
  W.msg(S.bar_x,S.bar_y+90fx,value,{scale = 4fx/5fx,ticks_before_fade = 40,is_optional = true})
end

function I.reset_messages()
  boom_timer = 0
  boom_count = 0
end

function I.screen_clear()
  screen = destroy_list(screen)
  screen.cursor = nil
end

local function add_text(x,y,value,scale,color)
  local id = text(x,y,value,scale,color,900fx)
  screen[#screen+1] = id
  return id
end

local function banner(y,title,color)
  add_text(500fx,y,title,T_TITLE,color)
end

local function place_cursor(index)
  if screen.cursor ~= nil and pewpew.entity_get_is_alive(screen.cursor) then
    local base = screen.row_base or 400fx
    local step = screen.row_step or C.MENU_STEP
    local x = screen.row_x or C.MENU_CURSOR_X
    W.place(screen.cursor,x,base-fmath.to_fixedpoint(index-1)*step)
  end
end

local function draw_menu(rows,colors,start_y,step,selection,cursor_x)
  for i = 1,#rows do
    local color = C.PAL.white
    if colors ~= nil and colors[i] ~= nil then
      color = colors[i]
    end
    add_text(500fx,start_y-fmath.to_fixedpoint(i-1)*step,rows[i],T_MENU,color)
  end
  screen.row_base = start_y
  screen.row_step = step
  screen.row_x = cursor_x
  if selection >= 1 then
    S.menu_sel = selection
    screen.cursor = entity(cursor_x,start_y-fmath.to_fixedpoint(selection-1)*step,31,C.PAL.cyan,1fx,400fx)
    screen[#screen+1] = screen.cursor
  else
    screen.cursor = nil
  end
end

function I.select(index)
  S.menu_sel = index
  place_cursor(index)
end

function I.move_selection(index)
  S.menu_sel = index
  place_cursor(index)
end

function I.screen_title(difficulty,hardcore,overclock,selection)
  I.screen_clear()
  banner(600fx,"PROGRESSBAR 95",C.PAL.cyan)
  add_text(500fx,556fx,"SYSTEM OVERDRIVE",T_SUB,C.PAL.hud)
  add_text(500fx,528fx,"FILL THE BAR. SURVIVE THE DESKTOP.",T_BODY,C.PAL.hud)
  local rows = {
    "START CAMPAIGN",
    "DIFFICULTY: "..difficulty,
    overclock and "OVERCLOCK MODE" or "OVERCLOCK: LOCKED",
    "HOW TO PLAY"
  }
  local colors = {C.PAL.white,C.PAL.white,C.PAL.white,C.PAL.white}
  if not overclock then
    colors[3] = C.PAL.locked
  end
  draw_menu(rows,colors,460fx,C.MENU_STEP,selection,C.MENU_CURSOR_X)
  local hint_y = 248
  if not hardcore then
    add_text(500fx,fmath.to_fixedpoint(hint_y),"HARDCORE UNLOCKS AT LEVEL "..tostring(C.HARDCORE_UNLOCK),T_SMALL,C.PAL.locked)
    hint_y = hint_y-26
  end
  if not overclock then
    add_text(500fx,fmath.to_fixedpoint(hint_y),"OVERCLOCK UNLOCKS AT LEVEL "..tostring(C.OVERCLOCK_UNLOCK),T_SMALL,C.PAL.locked)
  end
end

function I.screen_intro(level,def)
  I.screen_clear()
  banner(600fx,"LEVEL "..tostring(level),C.PAL.cyan)
  add_text(500fx,556fx,def.title,T_SUB,C.PAL.white)
  local y = 512
  local intro_lines = wrap(def.intro,44)
  for i = 1,#intro_lines do
    add_text(500fx,fmath.to_fixedpoint(y),intro_lines[i],T_BODY,C.PAL.hud)
    y = y-30
  end
  y = y-14
  local boss_line = "FILL 20 CELLS TO FINISH"
  if def.boss ~= nil then
    boss_line = "BOSS: "..def.boss.." MUST BE PURGED"
  end
  add_text(500fx,fmath.to_fixedpoint(y),boss_line,T_BODY,C.PAL.gold)
  y = y-44
  add_text(500fx,fmath.to_fixedpoint(y),"PULL SHOOT STICK TO START",T_MENU,C.PAL.white)
  y = y-40
  local help_lines = wrap("UP SCAN   RIGHT FIREWALL   DOWN DEFRAG   LEFT SLOW",44)
  for i = 1,#help_lines do
    add_text(500fx,fmath.to_fixedpoint(y),help_lines[i],T_SMALL,C.PAL.hud)
    y = y-26
  end
end

function I.screen_results(lines,selection)
  I.screen_clear()
  banner(620fx,"LEVEL COMPLETE",C.PAL.green)
  local y = 560
  for i = 1,#lines do
    local row_lines = wrap(lines[i],46)
    for j = 1,#row_lines do
      add_text(500fx,fmath.to_fixedpoint(y),row_lines[j],T_BODY,C.PAL.white)
      y = y-28
    end
  end
  y = y-24
  draw_menu({"CONTINUE","RETRY LEVEL"},{C.PAL.hud,C.PAL.hud},fmath.to_fixedpoint(y),C.MENU_STEP,selection,C.MENU_CURSOR_X)
end

function I.screen_overlay(title,subtitle,lines,options,selection,color)
  I.screen_clear()
  banner(620fx,title,color or C.PAL.cyan)
  local y = 566
  if subtitle ~= nil and subtitle ~= "" then
    add_text(500fx,fmath.to_fixedpoint(y),subtitle,T_SUB,C.PAL.hud)
    y = y-40
  end
  for i = 1,#lines do
    local row_lines = wrap(lines[i],46)
    for j = 1,#row_lines do
      add_text(500fx,fmath.to_fixedpoint(y),row_lines[j],T_BODY,C.PAL.white)
      y = y-28
    end
  end
  y = y-24
  draw_menu(options,nil,fmath.to_fixedpoint(y),C.MENU_STEP,selection,C.MENU_CURSOR_X)
end

local HELP = {
  {
    title = "CONTROLS",
    lines = {
      "MOVE STICK STEERS THE BAR",
      "THE BAR ROAMS THE WHOLE SCREEN",
      "SHOOT STICK CONFIRMS IN MENUS",
      "IN A LEVEL THE SHOOT STICK USES A TOOL"
    }
  },
  {
    title = "SEGMENTS",
    lines = {
      "BLUE ADDS ONE   CYAN ADDS TWO OR THREE",
      "YELLOW FILLS A CELL BUT COUNTS AS CORRUPT",
      "PINK DELETES YOUR NEWEST CELL",
      "GRAY ONLY SCORES   RED CRASHES YOU",
      "GREEN FILLS THE BAR   RANDOM IS A GAMBLE"
    }
  },
  {
    title = "TOOLS",
    lines = {
      "UP SCAN DESTROYS NEARBY REDS",
      "RIGHT FIREWALL BLOCKS ONE HIT",
      "DOWN DEFRAG CLEANS CORRUPT CELLS",
      "LEFT SLOW HALVES THE FALL SPEED",
      "FLICK TO A NEW DIRECTION TO SWITCH TOOL"
    }
  },
  {
    title = "SCORING",
    lines = {
      "FILL ALL 20 CELLS TO CLEAR A LEVEL",
      "NO CORRUPT CELLS MEANS PERFECT RATING",
      "BEAT THE PAR TIME FOR A SPEED BONUS",
      "HARDCORE IS ONE LIFE FOR DOUBLE SCORE",
      "OVERCLOCK UNLOCKS AT LEVEL 20"
    }
  }
}

function I.screen_help(page,selection)
  I.screen_clear()
  local entry = HELP[page] or HELP[1]
  banner(620fx,"HOW TO PLAY",C.PAL.cyan)
  add_text(500fx,574fx,entry.title.."   PAGE "..tostring(page).."/"..tostring(#HELP),T_SUB,C.PAL.hud)
  local y = 524
  for i = 1,#entry.lines do
    local rows = wrap(entry.lines[i],44)
    for j = 1,#rows do
      add_text(500fx,fmath.to_fixedpoint(y),rows[j],T_BODY,C.PAL.white)
      y = y-30
    end
  end
  local options = {"NEXT PAGE","BACK TO TITLE"}
  if page >= #HELP then
    options = {"BACK TO TITLE","FIRST PAGE"}
  end
  draw_menu(options,nil,fmath.to_fixedpoint(y-26),C.MENU_STEP,selection,C.MENU_CURSOR_X)
end

function I.help_pages()
  return #HELP
end

function I.screen_crash()
  I.screen_clear()
  I.hide_world()
  local panel = entity(500fx,350fx,14,0x1b3350ff,1fx,900fx)
  W.mesh_scale3(panel,6fx,4fx,1fx)
  screen[#screen+1] = panel
  add_text(500fx,420fx,"WARNING",T_TITLE,C.PAL.red)
  add_text(500fx,372fx,"BLUE SCREEN",T_SUB,C.PAL.cyan)
  add_text(500fx,330fx,"SYSTEM RECOVERY...",T_BODY,C.PAL.hud)
end

function I.rumble(x,y,color)
  W.explode(x,y,color,13fx/10fx,14)
end

return I
