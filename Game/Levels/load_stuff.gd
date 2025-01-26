extends Node2D

@export var next_level: String = "res://Game/Levels/Leiger/level_leiger.tscn"

func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file(next_level)