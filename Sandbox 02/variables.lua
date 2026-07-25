local variables = {}
-- root [5]
variables.root = "/dynamic/"
variables.file_end = ".lua"
variables.width = 3927fx
variables.height = 3927fx
variables.time = 0

-- game [5]
variables.wall = "add_wall"
variables.floating_msg = "new_floating_message"
variables.stop = "stop_game"
variables.camera_z = "camera_distance"
variables.explosion = "create_explosion"

-- player [6]
variables.conf_player = "configure_player"
variables.conf_player_weapon = "configure_player_ship_weapon"
variables.add_score = "increase_score_of_player"
variables.level_size = "set_level_size"
variables.new_ship = "new_player_ship"
variables.died = "has_lost"

-- enemies [1]
variables.baf = "new_baf"

-- logic [3]
variables.update = "add_update_callback"
variables.player_conf = "get_player_configuration"
variables.conf_player_hud = "configure_player_hud"

-- table [10]
variables.freq = "frequency"
variables.hidden = "is_optional"
variables.ticks = "ticks_before_fade"
variables.cannon_id = "cannon"
variables.top_left = "top_left_line"

variables.scale_xy = "scale"
variables.cannon_freq = "CannonFrequency"
variables.cannon_type = "CannonType"
variables.freq_10 = "FREQ_10"
variables.double = "DOUBLE"

-- fmath [6]
variables.atan = "atan2"
variables.to_fx = "to_fixedpoint"
variables.sin_cos = "sincos"
variables.rand_fx_point = "random_fixedpoint"
variables.get_int = "to_int"
variables.pi2 = "tau"

-- entity [17]
variables.damage_ship = "add_damage_to_player_ship"
variables.entity_get_pos = "entity_get_position"
variables.entity_mesh = "customizable_entity_set_mesh"
variables.entity = "new_customizable_entity"
variables.entity_alive = "entity_get_is_alive"

variables.entity_pos = "entity_set_position"
variables.entity_is_destroyed = "entity_get_is_started_to_be_destroyed"
variables.entity_radius = "entity_set_radius"
variables.entity_update = "entity_set_update_callback"
variables.entity_mesh_angle = "customizable_entity_set_mesh_angle"

variables.entity_player_collision = "customizable_entity_set_player_collision_callback"
variables.entity_weapon_collision = "customizable_entity_set_weapon_collision_callback"
variables.entity_wall_collision = "customizable_entity_configure_wall_collision"
variables.entity_exploding = "customizable_entity_start_exploding"
variables.entity_pos_interpolation = "customizable_entity_set_position_interpolation"

variables.entity_spawning = "customizable_entity_start_spawning"
variables.entity_hitbox = "customizable_entity_set_visibility_radius"

-- other [1]
variables.text = "print"
return variables
-- var: 55