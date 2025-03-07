extends InputHandler

@onready var hit_buffer: Timer = %HitBuffer

func set_dir() -> int:
	@warning_ignore("narrowing_conversion")
	return Input.get_axis("m2_left", "m2_right")

func set_bounce() -> bool:
	#HACK: References can be a bit fucked
	if not hit_buffer:
		hit_buffer = %HitBuffer
	#HACK: Can be a bit buggy
	if Input.is_action_just_pressed("a2_bounce") or wants_bounce:
		hit_buffer.start()
		return true
	return false

func _on_hit_buffer_timeout() -> void:
	wants_bounce = false