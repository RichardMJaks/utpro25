extends Node

# Player Properties
var speed = 600
var jump_force = 1200:
    get:
        return -jump_force
var bounce_force = 2000
var gravity_multiplier = 3

# Gameplay Properties
var total_health = 3
var top_throw_dir = Vector2.from_angle(PI/8)
var front_throw_dir = Vector2.from_angle(PI/4)

# Miscellaneous
enum SIDE {LEFT = 1, RIGHT = -1}