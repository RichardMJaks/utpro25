extends Node

# Player Properties
var speed = 700
var bounce_force_range = 300
var bounce_force = 2000:
    get:
        return bounce_force + \
            randf_range(
                -bounce_force_range/2.0, 
                bounce_force_range/2.0
            )
var gravity_multiplier = 3

# Gameplay Properties
var total_health = 3
var angle_range = 10
var top_throw_dir: 
    get: 
        var initial = -30
        return Vector2.from_angle(deg_to_rad(
            initial + randf_range(
                -angle_range/2.0,
                angle_range/2.0
            )
        )) 
var front_throw_dir:
    get: 
        var initial = -60
        return Vector2.from_angle(deg_to_rad(
            initial + randf_range(
                -angle_range/2.0,
                angle_range/2.0
            )
        ))

# Miscellaneous
enum SIDE {NONE = 0, LEFT = 1, RIGHT = -1}