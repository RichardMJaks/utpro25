extends InputHandler

@onready var hit_buffer: Timer = %HitBuffer

func _ready() -> void:
	hit_buffer.timeout.connect(_on_hit_buffer_timeout)

func set_dir() -> int:
	@warning_ignore("narrowing_conversion")
	return Input.get_axis("m2_left", "m2_right")

func set_bounce() -> bool:
	#HACK: References can be a bit fucked
	if not hit_buffer:
		hit_buffer = %HitBuffer
	if wants_bounce:
		return true
	if Input.is_action_just_pressed("a2_bounce"):
		hit_buffer.start()
		wants_front_bounce = true
		wants_top_bounce = false
		return true
	if Input.is_action_just_pressed("a2_bounce_top"):
		wants_top_bounce = true
		wants_front_bounce = false
		hit_buffer.start()
		return true

	wants_front_bounce = false
	wants_top_bounce = false	
	return false

func _on_hit_buffer_timeout() -> void:
	wants_bounce = false
	wants_front_bounce = false
	wants_top_bounce = false