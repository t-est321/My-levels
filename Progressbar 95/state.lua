local C = require("/dynamic/game_config.lua")

local S = {}

S.state = C.STATE.BOOT
S.tick = 0
S.state_tick = 0
S.level_tick = 0

S.level = 1
S.overclock = false
S.overclock_wave = 0
S.difficulty = "NORMAL"
S.lives = 3
S.max_lives = 3

S.bar_x = C.BAR_START_X
S.bar_y = C.BAR_START_Y
S.bar_vx = 0fx
S.bar_vy = 0fx

S.time_scale = 1fx
S.slow_timer = 0
S.firewall_timer = 0
S.invuln = 0
S.crash_timer = 0

S.score_mul_num = 1
S.score_mul_den = 1

S.charges = {scan = 2,firewall = 2,defrag = 2,slow = 2}
S.charges_used = 0
S.firewall_uses = 0
S.scan_uses = 0

S.def = nil
S.boss = nil
S.boss_id = nil

S.spawn_acc = 0fx
S.popup_acc = 0fx
S.pattern_step = 0
S.blue_streak = 0
S.spawn_attempts = 0

S.combo_count = 0
S.combo_max = 0
S.combo_timer = 0
S.combo_mult_num = 1
S.combo_mult_den = 1

S.seg = {}
S.seg_order = {}
S.pop = {}
S.pop_order = {}
S.shot = {}
S.shot_order = {}
S.cells = {}

S.level_score_start = 0
S.level_time = 0
S.damage = 0
S.gray_at_zero = 0
S.pink_at_zero = 0
S.green_used = false
S.yellow_taken = 0
S.blue_taken = 0
S.crash_count = 0

S.unlocked_hardcore = true
S.unlocked_overclock = false
S.campaign_score = 0
S.campaign_ticks = 0

S.menu_sel = 1
S.help_page = 1
S.menu_confirm_lock = false
S.menu_move_lock = 0

S.ship_id = nil
S.result = nil
S.hooks = {}

S.terminal = false
S.hud_last = ""
S.screen_dirty = true
S.msg_last = ""

S.green_spawned = 0
S.freeze_timer = 0
S.boost_timer = 0
S.mod_timer = 0
S.mod_phase = 0
S.zone_x = 500fx
S.zone_y = 500fx
S.zone_id = nil
S.seq = {}
S.seq_index = 0
S.seq_show = 0
S.boss_corrupt = false
S.boss_scan_stun = 0
S.pending_complete = false
S.spawn_pity = 0
S.red_live = 0
S.cyan_live = 0

S.util_lock = 0
S.util_edge = false
S.shoot_dir = nil

S.menu_armed = false

S.menu_push = false

return S
