## Override this class's methods to simulate different behaviours
extends Node
class_name InputHandler

var wants_bounce: bool = false:
	get:
		if wants_bounce:
			wants_bounce = false
			return true
		return false
var dir: int = 0

func _process(_delta: float) -> void:
	dir = set_dir()

func _physics_process(_delta: float) -> void:
	wants_bounce = set_bounce()

func set_dir() -> int:
	return 0

func set_bounce() -> bool:
	return false 