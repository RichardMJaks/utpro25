extends Node2D

@export var next_level: String = "res://Game/Levels/Leiger/level_leiger.tscn"

func _process(delta: float) -> void:
	$ColorRect/ProgressBar.max_value = $Timer.wait_time - 1
	$ColorRect/ProgressBar.value = $Timer.wait_time - 1 - $Timer.time_left

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(next_level)
