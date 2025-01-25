extends RigidBody2D
class_name Volleyball

func make_invisible() -> void:
	freeze = true
	visible = false

func make_visible() -> void:
	freeze = false
	visible = true
