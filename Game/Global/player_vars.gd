extends Node

# Player Properties
var speed = 600
var bounce_force = 2000
var gravity_multiplier = 3

# Gameplay Properties
var total_health = 3
var top_throw_dir = Vector2.from_angle(deg_to_rad(-45))
var front_throw_dir = Vector2.from_angle(deg_to_rad(-45))

# Miscellaneous
enum SIDE {NONE = 0, LEFT = 1, RIGHT = -1}