extends InputHandler

@onready var volleyball: Volleyball = get_tree().current_scene.volleyball
@export var prediction_delta: float = 0.05
@export var error_margin: float = 20
@export var rethrow_delay: float = 1
var throw_blocked: bool = false

func set_dir() -> int:
	var pos = _calculate_trajectory()
	
	if (pos - owner.global_position.x) < -error_margin:
		return -1
	elif (pos - owner.global_position.x) > error_margin:
		return 1
	
	return 0

func _calculate_trajectory() -> int:
	var start_pos = volleyball.global_position
	var v = volleyball.linear_velocity
	var damp = volleyball.linear_damp
	var g = volleyball.get_gravity()
	var t = prediction_delta

	var final_pos
	if damp == 0:
		final_pos = start_pos + v * t + 0.5 * g * t * t
	else:
		var start = start_pos
		var vel_differential = (v / damp) * (1 - exp(-damp * t))
		var gravity_differential = (g / pow(damp, 2)) * (damp * t - 1 + exp(-damp * t))
		final_pos = start + vel_differential + gravity_differential
	return final_pos.x

func set_bounce() -> bool:
	if true in owner.throw_areas and not throw_blocked:
		throw_blocked = true
		_create_throw_timer()
		return true
	return false

func _create_throw_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = rethrow_delay
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(
		func():
			throw_blocked = false
			timer.queue_free()
	)
	return add_child(timer)
