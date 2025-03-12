extends Label

@export var player: int = 1

var PREFIX: Array[String] = ["p1_", "p2_"]
func _process(_delta: float) -> void:
	text = MPVars.CHARACTER.find_key(MPVars.get(PREFIX[player - 1] + "character"))
