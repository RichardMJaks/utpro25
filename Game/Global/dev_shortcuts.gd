extends Node

signal global_lose()
signal global_win()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("dev_menu"):
		get_tree().change_scene_to_file("res://Game/Menus/main_menu.tscn")
