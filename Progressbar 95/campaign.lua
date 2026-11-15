local C = require("/dynamic/game_config.lua")

local campaign = {}

local function level(entry)
  if entry.weights == nil then
    entry.weights = {}
  end
  entry.weights.blue = entry.weights.blue or 0
  entry.weights.cyan = entry.weights.cyan or 0
  entry.weights.yellow = entry.weights.yellow or 0
  entry.weights.red = entry.weights.red or 0
  entry.weights.pink = entry.weights.pink or 0
  entry.weights.gray = entry.weights.gray or 0
  entry.weights.green = entry.weights.green or 0
  entry.weights.random = entry.weights.random or 0
  if entry.charges == nil then
    entry.charges = {scan = 1,firewall = 1,defrag = 1,slow = 1}
  end
  entry.red_limit = entry.red_limit or 0
  entry.cyan_limit = entry.cyan_limit or 3
  entry.random_limit = entry.random_limit or 2
  entry.green_limit = entry.green_limit or 0
  entry.popup_rate = entry.popup_rate or 0
  entry.wobble = entry.wobble or 0fx
  entry.current = entry.current or 0fx
  entry.modifier = entry.modifier or "none"
  entry.pattern = entry.pattern or "single"
  entry.boss = entry.boss or nil
  entry.intro = entry.intro or entry.title
  return entry
end

campaign.levels = {
  level({
    title = "BOOT CAMP",
    intro = "MOVE JOYSTICK: steer the bar. CATCH BLUE BARS.",
    seed = 2101,
    interval = 34,
    speed = 5fx,
    wobble = 0fx,
    pattern = "single",
    weights = {blue = 100},
    charges = {scan = 1,firewall = 1,defrag = 1,slow = 1},
    par = 900,
    modifier = "tutorial"
  }),
  level({
    title = "FIRST SEGMENT",
    intro = "YELLOW CELLS FILL THE BAR BUT LOWER YOUR RATING.",
    seed = 2102,
    interval = 30,
    speed = 5fx+1fx/2fx,
    wobble = 6fx,
    pattern = "single",
    weights = {blue = 78,yellow = 22},
    charges = {scan = 1,firewall = 1,defrag = 1,slow = 1},
    par = 900,
    modifier = "tutorial"
  }),
  level({
    title = "CORRUPTION",
    intro = "PINK REMOVES YOUR NEWEST CELL. CYAN x2 ADDS TWO.",
    seed = 2103,
    interval = 28,
    speed = 6fx,
    wobble = 10fx,
    pattern = "single",
    weights = {blue = 62,yellow = 20,pink = 10,cyan = 8},
    charges = {scan = 1,firewall = 1,defrag = 1,slow = 1},
    par = 900,
    modifier = "tutorial"
  }),
  level({
    title = "TOOLKIT",
    intro = "SHOOT STICK: UP SCAN, RIGHT FIREWALL, DOWN DEFRAG, LEFT SLOW.",
    seed = 2104,
    interval = 26,
    speed = 6fx,
    wobble = 14fx,
    pattern = "single",
    weights = {blue = 60,yellow = 18,pink = 8,red = 8,gray = 6},
    red_limit = 2,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 960,
    modifier = "tutorial"
  }),
  level({
    title = "POPUP WORKSHOP",
    intro = "WINDOWS DRIFT ACROSS THE DESKTOP. SCAN CLEARS THEM.",
    seed = 2105,
    interval = 26,
    speed = 6fx,
    wobble = 16fx,
    pattern = "pair",
    weights = {blue = 62,yellow = 16,pink = 8,red = 6,gray = 8},
    red_limit = 2,
    popup_rate = 190,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 2},
    par = 1050,
    modifier = "popup"
  }),
  level({
    title = "WOBBLE FIELD",
    intro = "SEGMENTS WEAVE. LEAD YOUR CATCH, NOT YOUR REACTION.",
    seed = 2106,
    interval = 25,
    speed = 7fx,
    wobble = 46fx,
    pattern = "single",
    weights = {blue = 62,yellow = 18,pink = 8,red = 6,cyan = 6},
    red_limit = 2,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1080,
    modifier = "wobble"
  }),
  level({
    title = "LANE DISCIPLINE",
    intro = "STRAIGHT COLUMNS. CUT ACROSS, DO NOT PANIC.",
    seed = 2107,
    interval = 24,
    speed = 8fx,
    wobble = 0fx,
    pattern = "lanes",
    weights = {blue = 58,yellow = 18,pink = 8,red = 8,gray = 8},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1080,
    modifier = "lanes"
  }),
  level({
    title = "DICE ROLL",
    intro = "RANDOM SEGMENTS ROLL A COLOR WHEN THEY LAND. RISK IT.",
    seed = 2108,
    interval = 24,
    speed = 8fx,
    wobble = 20fx,
    pattern = "single",
    weights = {blue = 50,yellow = 14,pink = 8,red = 6,random = 16,cyan = 6},
    red_limit = 2,
    random_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1140,
    modifier = "random"
  }),
  level({
    title = "THE GREEN KEY",
    intro = "GREEN FILLS THE WHOLE BAR. IT IS FAST AND RARE.",
    seed = 2109,
    interval = 24,
    speed = 8fx,
    wobble = 24fx,
    pattern = "pair",
    weights = {blue = 52,yellow = 16,pink = 8,red = 6,gray = 8,green = 3,cyan = 7},
    red_limit = 2,
    green_limit = 1,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1140,
    modifier = "green"
  }),
  level({
    title = "CLIPPY.EXE",
    intro = "IT LOOKS LIKE HELP. IT IS NOT. THREE PHASES.",
    seed = 2110,
    interval = 26,
    speed = 7fx,
    wobble = 18fx,
    pattern = "pair",
    weights = {blue = 58,yellow = 16,pink = 8,red = 6,cyan = 6,gray = 6},
    red_limit = 3,
    charges = {scan = 3,firewall = 3,defrag = 2,slow = 2},
    par = 2400,
    boss = "CLIPPY",
    modifier = "boss"
  }),
  level({
    title = "BOUNCE HOUSE",
    intro = "SEGMENTS BOUNCE OFF THE DESKTOP EDGES.",
    seed = 2111,
    interval = 24,
    speed = 7fx,
    wobble = 10fx,
    pattern = "fan",
    weights = {blue = 58,yellow = 16,pink = 8,red = 6,gray = 6,cyan = 6},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1140,
    modifier = "bounce"
  }),
  level({
    title = "DIAGONAL DRIFT",
    intro = "A LATERAL CURRENT PUSHES EVERY SEGMENT.",
    seed = 2112,
    interval = 23,
    speed = 7fx,
    wobble = 12fx,
    current = 18fx,
    pattern = "single",
    weights = {blue = 56,yellow = 18,pink = 8,red = 6,gray = 6,cyan = 6},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1140,
    modifier = "current"
  }),
  level({
    title = "FREEZE FRAME",
    intro = "THE SYSTEM STALLS IN TELEGRAPHED FREEZES. USE THEM.",
    seed = 2113,
    interval = 22,
    speed = 8fx,
    wobble = 20fx,
    pattern = "pair",
    weights = {blue = 55,yellow = 17,pink = 8,red = 8,gray = 6,cyan = 6},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1200,
    modifier = "freeze"
  }),
  level({
    title = "DECOY DUTY",
    intro = "SOME BLUE BARS ARE FAKE. SCAN EXPOSES THEM.",
    seed = 2114,
    interval = 22,
    speed = 8fx,
    wobble = 24fx,
    pattern = "single",
    weights = {blue = 50,yellow = 16,pink = 8,red = 6,gray = 8,cyan = 6,random = 6},
    red_limit = 3,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 2},
    par = 1200,
    modifier = "decoy"
  }),
  level({
    title = "FRAGMENTATION",
    intro = "YELLOW CHAINS FALL IN FORMATION. DEFRAG CLEANS THEM.",
    seed = 2115,
    interval = 20,
    speed = 8fx,
    wobble = 14fx,
    pattern = "chain",
    weights = {blue = 50,yellow = 30,pink = 8,red = 4,gray = 4,cyan = 4},
    red_limit = 2,
    charges = {scan = 2,firewall = 2,defrag = 3,slow = 2},
    par = 1260,
    modifier = "chains"
  }),
  level({
    title = "PRIVACY PLEASE",
    intro = "WINDOWS COVER THE FIELD. TOUCHING ONE COSTS A SHIELD.",
    seed = 2116,
    interval = 22,
    speed = 8fx,
    wobble = 18fx,
    pattern = "pair",
    weights = {blue = 54,yellow = 16,pink = 8,red = 6,gray = 8,cyan = 8},
    red_limit = 3,
    popup_rate = 150,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 2},
    par = 1260,
    modifier = "privacy"
  }),
  level({
    title = "CLOSE THE WINDOW",
    intro = "MARKED WINDOWS HAVE A CLOSE BOX. TOUCH IT WITH THE BAR.",
    seed = 2117,
    interval = 22,
    speed = 8fx,
    wobble = 16fx,
    pattern = "single",
    weights = {blue = 54,yellow = 16,pink = 8,red = 6,gray = 8,cyan = 8},
    red_limit = 3,
    popup_rate = 130,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 2},
    par = 1260,
    modifier = "closable"
  }),
  level({
    title = "SCANLINE",
    intro = "LASER SCANLINES SWEEP THE DESKTOP. WATCH THE WARNING.",
    seed = 2118,
    interval = 21,
    speed = 9fx,
    wobble = 14fx,
    pattern = "lanes",
    weights = {blue = 54,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 6},
    red_limit = 3,
    popup_rate = 170,
    charges = {scan = 2,firewall = 3,defrag = 2,slow = 3},
    par = 1320,
    modifier = "scanline"
  }),
  level({
    title = "DIGITAL RAIN",
    intro = "STRAIGHT STREAMS. NO WOBBLE. PURE POSITIONING.",
    seed = 2119,
    interval = 18,
    speed = 10fx,
    wobble = 0fx,
    pattern = "matrix",
    weights = {blue = 52,yellow = 18,pink = 10,red = 8,gray = 6,cyan = 6},
    red_limit = 4,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1320,
    modifier = "matrix"
  }),
  level({
    title = "POPUP.STORM",
    intro = "THREE WAVES OF WINDOWS. MIND THE GAPS.",
    seed = 2120,
    interval = 24,
    speed = 8fx,
    wobble = 12fx,
    pattern = "pair",
    weights = {blue = 56,yellow = 16,pink = 8,red = 6,cyan = 8,gray = 6},
    red_limit = 3,
    popup_rate = 110,
    charges = {scan = 4,firewall = 3,defrag = 2,slow = 3},
    par = 2700,
    boss = "STORM",
    modifier = "boss"
  }),
  level({
    title = "MAGNET CLASS",
    intro = "YELLOW BARS CURVE TOWARD YOU. STAY CLEAN.",
    seed = 2121,
    interval = 20,
    speed = 9fx,
    wobble = 12fx,
    pattern = "single",
    weights = {blue = 50,yellow = 24,pink = 8,red = 6,gray = 6,cyan = 6},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 3,slow = 2},
    par = 1320,
    modifier = "magnet"
  }),
  level({
    title = "ARMOR PLATING",
    intro = "ARMORED WINDOWS NEED TWO SCANS OR A WIDE BERTH.",
    seed = 2122,
    interval = 20,
    speed = 9fx,
    wobble = 16fx,
    pattern = "pair",
    weights = {blue = 52,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 3,
    popup_rate = 140,
    charges = {scan = 4,firewall = 2,defrag = 2,slow = 2},
    par = 1380,
    modifier = "armor"
  }),
  level({
    title = "REVERSE BELT",
    intro = "CONVEYOR LANES REVERSE. READ THE ARROWS.",
    seed = 2123,
    interval = 20,
    speed = 9fx,
    wobble = 8fx,
    current = 26fx,
    pattern = "columns",
    weights = {blue = 52,yellow = 18,pink = 8,red = 8,gray = 6,cyan = 8},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1380,
    modifier = "conveyor"
  }),
  level({
    title = "BLUE OVER SPEED",
    intro = "CHOICE PAIRS: TAKE BLUE FOR RATING, YELLOW FOR SPEED.",
    seed = 2124,
    interval = 20,
    speed = 9fx,
    wobble = 10fx,
    pattern = "choice",
    weights = {blue = 40,yellow = 40,pink = 6,red = 4,gray = 4,cyan = 6},
    red_limit = 2,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1380,
    modifier = "choice"
  }),
  level({
    title = "NULL POINTER",
    intro = "GRAY CHANGES NOTHING. TAKE FIVE AT ZERO PROGRESS TO PROVE IT.",
    seed = 2125,
    interval = 20,
    speed = 9fx,
    wobble = 14fx,
    pattern = "single",
    weights = {blue = 34,gray = 30,yellow = 12,pink = 14,red = 4,cyan = 6},
    red_limit = 2,
    cyan_limit = 2,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1440,
    modifier = "null"
  }),
  level({
    title = "CURRENT AND WOBBLE",
    intro = "TWO MODIFIERS AT ONCE. NOT THREE.",
    seed = 2126,
    interval = 19,
    speed = 9fx,
    wobble = 40fx,
    current = 16fx,
    pattern = "pair",
    weights = {blue = 52,yellow = 18,pink = 8,red = 8,gray = 6,cyan = 8},
    red_limit = 3,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1440,
    modifier = "combo_current_wobble"
  }),
  level({
    title = "POPUPS WITH AIM",
    intro = "WINDOWS SHOOT BACK NOW. TELEGRAPHED, ALWAYS.",
    seed = 2127,
    interval = 19,
    speed = 10fx,
    wobble = 16fx,
    pattern = "pair",
    weights = {blue = 52,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 3,
    popup_rate = 150,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 2},
    par = 1440,
    modifier = "combo_popup_aim"
  }),
  level({
    title = "SCANLINES AND LANES",
    intro = "SWEEPS ACROSS STRAIGHT FALLING COLUMNS.",
    seed = 2128,
    interval = 18,
    speed = 10fx,
    wobble = 6fx,
    pattern = "lanes",
    weights = {blue = 52,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 4,
    popup_rate = 160,
    charges = {scan = 2,firewall = 3,defrag = 2,slow = 2},
    par = 1500,
    modifier = "combo_scanline_lanes"
  }),
  level({
    title = "RANDOM AND SCAN",
    intro = "ONE SCAN CHARGE. ROLL THE DICE CAREFULLY.",
    seed = 2129,
    interval = 18,
    speed = 10fx,
    wobble = 18fx,
    pattern = "single",
    weights = {blue = 44,yellow = 12,pink = 8,red = 6,random = 22,gray = 4,cyan = 4},
    red_limit = 3,
    random_limit = 4,
    charges = {scan = 1,firewall = 2,defrag = 2,slow = 2},
    par = 1500,
    modifier = "combo_random_scan"
  }),
  level({
    title = "DEFRAGMENTOR",
    intro = "ROTATING RINGS AND A CORRUPTED SHIELD. DEFRAG OPENS IT.",
    seed = 2130,
    interval = 22,
    speed = 8fx,
    wobble = 14fx,
    pattern = "chain",
    weights = {blue = 48,yellow = 26,pink = 8,red = 6,gray = 6,cyan = 6},
    red_limit = 3,
    charges = {scan = 3,firewall = 3,defrag = 1,slow = 2},
    par = 3000,
    boss = "DEFRAG",
    modifier = "boss"
  }),
  level({
    title = "OVERCLOCK CYCLE",
    intro = "THE CPU SPEEDS UP IN TELEGRAPHED CYCLES.",
    seed = 2131,
    interval = 18,
    speed = 9fx,
    wobble = 20fx,
    pattern = "pair",
    weights = {blue = 52,yellow = 16,pink = 8,red = 8,gray = 6,cyan = 10},
    red_limit = 4,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1500,
    modifier = "overclock_cycle"
  }),
  level({
    title = "SPLIT STREAMS",
    intro = "TWO STREAMS, TWO DIRECTIONS. PICK A SIDE.",
    seed = 2132,
    interval = 18,
    speed = 10fx,
    wobble = 10fx,
    pattern = "split",
    weights = {blue = 50,yellow = 18,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 4,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1560,
    modifier = "split"
  }),
  level({
    title = "PHANTOM BLUE",
    intro = "FAKE BLUE LOOKS RIGHT. THE CORNER NOTCH IS THE TELL.",
    seed = 2133,
    interval = 18,
    speed = 10fx,
    wobble = 18fx,
    pattern = "single",
    weights = {blue = 46,yellow = 14,pink = 8,red = 6,gray = 14,cyan = 6,random = 6},
    red_limit = 3,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 2},
    par = 1560,
    modifier = "phantom"
  }),
  level({
    title = "MOVING SAFE ZONE",
    intro = "A GREY ZONE DRIFTS. STAND IN IT WHEN THE SWEEP COMES.",
    seed = 2134,
    interval = 18,
    speed = 10fx,
    wobble = 14fx,
    pattern = "lanes",
    weights = {blue = 50,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 4,
    popup_rate = 150,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1560,
    modifier = "zone"
  }),
  level({
    title = "MATRIX OVERDRIVE",
    intro = "STRAIGHT STREAMS AND A MEMORISED LANE ORDER.",
    seed = 2135,
    interval = 16,
    speed = 11fx,
    wobble = 0fx,
    pattern = "sequence",
    weights = {blue = 50,yellow = 16,pink = 8,red = 10,gray = 8,cyan = 8},
    red_limit = 4,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1560,
    modifier = "sequence"
  }),
  level({
    title = "TRIAD",
    intro = "THREE MECHANICS. NO MORE THAN THREE.",
    seed = 2136,
    interval = 16,
    speed = 11fx,
    wobble = 30fx,
    current = 14fx,
    pattern = "pair",
    weights = {blue = 50,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 4,
    popup_rate = 170,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1560,
    modifier = "triad"
  }),
  level({
    title = "TRIAD II",
    intro = "LANES, SCANLINES, AND RANDOM TOGETHER.",
    seed = 2137,
    interval = 15,
    speed = 11fx,
    wobble = 12fx,
    pattern = "lanes",
    weights = {blue = 46,yellow = 14,pink = 8,red = 8,gray = 8,cyan = 8,random = 8},
    red_limit = 4,
    random_limit = 3,
    popup_rate = 160,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 3},
    par = 1560,
    modifier = "triad_two"
  }),
  level({
    title = "TRIAD III",
    intro = "STREAMS, DECOYS, AND A MOVING ZONE.",
    seed = 2138,
    interval = 15,
    speed = 12fx,
    wobble = 8fx,
    pattern = "matrix",
    weights = {blue = 46,yellow = 14,pink = 8,red = 8,gray = 12,cyan = 8,random = 4},
    red_limit = 4,
    popup_rate = 150,
    charges = {scan = 3,firewall = 2,defrag = 2,slow = 3},
    par = 1560,
    modifier = "triad_three"
  }),
  level({
    title = "LAST GAUNTLET",
    intro = "EVERYTHING YOU LEARNED. ONE MORE GREEN IF YOU ARE LUCKY.",
    seed = 2139,
    interval = 14,
    speed = 12fx,
    wobble = 24fx,
    current = 12fx,
    pattern = "fan",
    weights = {blue = 48,yellow = 16,pink = 8,red = 9,gray = 8,cyan = 8,green = 3},
    red_limit = 5,
    green_limit = 1,
    popup_rate = 150,
    charges = {scan = 3,firewall = 3,defrag = 3,slow = 3},
    par = 1560,
    modifier = "gauntlet"
  }),
  level({
    title = "KERNEL.BSOD",
    intro = "FOUR PHASES. THIS IS THE KERNEL. DO NOT BLINK.",
    seed = 2140,
    interval = 20,
    speed = 9fx,
    wobble = 16fx,
    pattern = "pair",
    weights = {blue = 52,yellow = 16,pink = 8,red = 8,gray = 8,cyan = 8},
    red_limit = 4,
    popup_rate = 150,
    charges = {scan = 3,firewall = 3,defrag = 2,slow = 3},
    par = 4200,
    boss = "KERNEL",
    modifier = "boss"
  })
}

local function clamp_fx(value,low,high)
  if value < low then
    return low
  end
  if value > high then
    return high
  end
  return value
end

campaign.overclock = function(wave)
  local step = wave-1
  if step < 0 then
    step = 0
  end
  local speed = 8fx+fmath.from_fraction(step,2)
  speed = clamp_fx(speed,8fx,14fx)
  local interval = 24-step
  if interval < 12 then
    interval = 12
  end
  local red = 6+step//3
  if red > 16 then
    red = 16
  end
  local wobble = 10fx+step*2fx
  wobble = clamp_fx(wobble,10fx,60fx)
  local scripts = {"single","pair","lanes","fan","split","matrix","chain","columns"}
  local modifiers = {"current","wobble","lanes","decoy","scanline","random","conveyor","split"}
  local def = level({
    title = "OVERCLOCK "..tostring(wave),
    intro = "ESCALATION WAVE "..tostring(wave)..". SPEED AND PATTERNS ARE CAPPED.",
    seed = 7000+wave*37,
    interval = interval,
    speed = speed,
    wobble = wobble,
    current = 6fx+step*2fx,
    pattern = scripts[wave%#scripts+1],
    weights = {
      blue = 46,yellow = 16,pink = 8,gray = 8,cyan = 8,
      red = red,random = 6
    },
    red_limit = 3+step//2,
    random_limit = 2,
    popup_rate = 160,
    charges = {scan = 2,firewall = 2,defrag = 2,slow = 2},
    par = 1500,
    modifier = modifiers[wave%#modifiers+1],
    overclock = true
  })
  def.red_limit = def.red_limit > 6 and 6 or def.red_limit
  return def
end

return campaign