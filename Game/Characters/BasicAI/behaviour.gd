extends InputHandler

@onready var cs = get_tree().current_scene

@onready var volleyball: Volleyball = await cs.volleyball
@export var prediction_delta: float = 0.05
@export var error_margin: float = 20
@export var alternative_prediction: bool = false

# Get helpers
@onready var midpoint: Marker2D = cs.midpoint 
@onready var island_midpoint: Marker2D = cs.island_midpoint 

func _process(delta: float) -> void:
	if not volleyball:
		if cs.volleyball and not cs.volleyball.is_queued_for_deletion():
			volleyball = cs.volleyball

	super(delta)

func set_dir() -> int:
	if not volleyball:
		return 0

	var pos = _calculate_trajectory()
	
	if volleyball.global_position.x < midpoint.global_position.x and not alternative_prediction:
		pos = island_midpoint.global_position.x

	if (pos - owner.global_position.x) < -error_margin:
		return -1
	elif (pos - owner.global_position.x) > error_margin:
		return 1
	
	return 0

func _alternative_pd() -> float:
	return (volleyball.global_position - owner.global_position).length() / 1500


func _calculate_trajectory() -> int:
	var start_pos = volleyball.global_position
	var v = volleyball.linear_velocity
	var damp = volleyball.linear_damp
	var g = volleyball.get_gravity()
	var t = prediction_delta if not alternative_prediction else _alternative_pd()

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
	return true in owner.throw_areas 
