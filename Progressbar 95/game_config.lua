local C = {}

C.ARENA_W = 1000fx
C.ARENA_H = 700fx
C.CELLS = 20
C.CELL_W = 24fx
C.BAR_HW = 240fx
C.BAR_HH = 16fx
C.BAR_MIN_X = 260fx
C.BAR_MAX_X = 740fx
C.BAR_MIN_Y = 140fx
C.BAR_MAX_Y = 640fx
C.CAM_X = 500fx
C.CAM_Y = 350fx
C.MENU_X = 500fx
C.MENU_Y = 470fx
C.BAR_START_X = 500fx
C.BAR_START_Y = 245fx
C.BAR_SPEED = 16fx
C.BAR_SMOOTH = 5fx
C.MOVE_DEADZONE = 1fx/8fx
C.SHOOT_PRESS = 1fx/4fx
C.UTIL_LOCK = 8
C.HELP_PAGES = 4

C.HUD_PAD_X = 35fx
C.HUD_PAD_Y = 45fx
C.HUD_ICON_GAP = 45fx
C.MENU_CURSOR_X = 200fx
C.MENU_STEP = 42fx
C.MENU_TEXT_SCALE = 1fx

C.COMBO_MAX = 3
C.COMBO_TIER_1 = 5
C.COMBO_TIER_2 = 10
C.COMBO_TIER_3 = 15
C.COMBO_TIER_4 = 20
C.COMBO_MULT_1 = 10
C.COMBO_MULT_2 = 15
C.COMBO_MULT_3 = 25
C.COMBO_MULT_4 = 30
C.COMBO_DECAY = 120

C.SEG_HALF = 15fx
C.SPAWN_Y = 700fx
C.DESPAWN_Y = 110fx

C.MAX_ENTITIES = 350
C.MAX_SEGMENTS = 26
C.MAX_POPUPS = 10
C.MAX_SHOTS = 24

C.MESH = "/dynamic/graphics.lua"
C.SOUND = "/dynamic/sounds.lua"

C.BLUE = 1
C.CYAN2 = 2
C.CYAN3 = 3
C.YELLOW = 4
C.RED = 5
C.PINK = 6
C.GRAY = 7
C.GREEN = 8
C.RANDOM = 9

C.SEG = {
  {
    name = "blue",
    color = 0x2f7bffff,
    symbol = "B",
    mesh = 3,
    add = 1,
    score = 10
  },
  {
    name = "cyan2",
    color = 0x22d3eeff,
    symbol = "x2",
    mesh = 4,
    add = 2,
    score = 25
  },
  {
    name = "cyan3",
    color = 0x66f0ffff,
    symbol = "x3",
    mesh = 5,
    add = 3,
    score = 40
  },
  {
    name = "yellow",
    color = 0xffc400ff,
    symbol = "Y",
    mesh = 6,
    add = 1,
    score = 6
  },
  {
    name = "red",
    color = 0xff2b4aff,
    symbol = "!",
    mesh = 7,
    add = 0,
    score = 0
  },
  {
    name = "pink",
    color = 0xff3ba0ff,
    symbol = "-",
    mesh = 8,
    add = 0,
    score = 0
  },
  {
    name = "gray",
    color = 0x8892a6ff,
    symbol = "0",
    mesh = 9,
    add = 0,
    score = 2
  },
  {
    name = "green",
    color = 0x33ff88ff,
    symbol = "G",
    mesh = 10,
    add = 20,
    score = 200
  },
  {
    name = "random",
    color = 0xff22ffff,
    symbol = "?",
    mesh = 11,
    add = 0,
    score = 5
  }
}

C.PAL = {
  bg = 0x0a1020ff,
  desk = 0x0d2233ff,
  panel = 0x101a2eff,
  border = 0xb8c6d9ff,
  dim = 0x33455fff,
  cyan = 0x22d3eeff,
  teal = 0x0f3b4aff,
  white = 0xffffffff,
  hud = 0x9fe8ffff,
  gold = 0xffc400ff,
  red = 0xff2b4aff,
  green = 0x33ff88ff,
  pink = 0xff3ba0ff,
  amber = 0xffa000ff,
  locked = 0x55606eff
}

C.UTIL = {
  {name = "SCAN",key = "scan",icon = 21,color = 0x33ff88ff},
  {name = "FIREWALL",key = "firewall",icon = 22,color = 0x22d3eeff},
  {name = "DEFRAG",key = "defrag",icon = 23,color = 0xffc400ff},
  {name = "SLOW",key = "slow",icon = 24,color = 0xff3ba0ff}
}

C.FIREWALL_TICKS = 180
C.SLOW_TICKS = 90
C.SCAN_RADIUS = 170fx
C.INVULN_TICKS = 70
C.CRASH_TICKS = 55

C.HARDCORE_UNLOCK = 10
C.OVERCLOCK_UNLOCK = 20
C.DIFF_ORDER = {"RELAX","NORMAL","HARDCORE"}

C.DIFF = {
  RELAX = {
    lives = 2,
    speed = 4fx/5fx,
    density = 6fx/5fx,
    red = 1fx/2fx,
    warn = 34,
    num = 1,
    den = 2,
    charge_bonus = {scan = 1,firewall = 1,defrag = 0,slow = 1}
  },
  NORMAL = {
    lives = 3,
    speed = 1fx,
    density = 1fx,
    red = 1fx,
    warn = 30,
    num = 1,
    den = 1,
    charge_bonus = {scan = 0,firewall = 0,defrag = 0,slow = 0}
  },
  HARDCORE = {
    lives = 1,
    speed = 23fx/20fx,
    density = 4fx/5fx,
    red = 7fx/4fx,
    warn = 20,
    num = 2,
    den = 1,
    charge_bonus = {scan = -1,firewall = -1,defrag = 0,slow = 0}
  },
  OVERCLOCK = {
    lives = 1,
    speed = 6fx/5fx,
    density = 2fx/3fx,
    red = 3fx/2fx,
    warn = 20,
    num = 2,
    den = 1,
    charge_bonus = {scan = 0,firewall = 0,defrag = 0,slow = 0}
  }
}

C.SCORE_COMPLETE = 300
C.SCORE_PURITY = 250
C.SCORE_NODAMAGE = 150
C.SCORE_NULL = 200
C.SCORE_SPEED = 200
C.SCORE_MAGIC = 150

C.STATE = {
  BOOT = "BOOT",
  TITLE = "TITLE",
  INTRO = "INTRO",
  PLAY = "PLAY",
  CRASH = "CRASH",
  RESULTS = "RESULTS",
  GAMEOVER = "GAMEOVER",
  COMPLETE = "COMPLETE",
  HELP = "HELP"
}

return C
