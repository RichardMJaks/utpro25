extends Label

func _process(delta: float) -> void:
	text = MPVars.CHARACTER.find_key(MPVars.p1_character) + MPVars.CHARACTER.find_key(MPVars.p2_character)
