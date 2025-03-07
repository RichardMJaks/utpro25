extends Control

@onready var fader: ColorRect = %Fader

func _ready() -> void:
	_fade_in(2)

func set_player_1(character: MPVars.CHARACTER) -> void:
	MPVars.p1_character = character

func set_player_2(character: MPVars.CHARACTER) -> void:
	MPVars.p2_character = character

func _fade_in(tween_time: float) -> Tween:
	var tween: Tween = fader.create_tween()
	tween.tween_property(fader, "color:a", 0, tween_time)\
		.set_ease(Tween.EASE_IN)
	
	return tween

func _fade_out(tween_time: float) -> Tween:
	var tween: Tween = fader.create_tween()
	tween.tween_property(fader, "color:a", 1, tween_time)\
		.set_ease(Tween.EASE_OUT)
	
	return tween

func _on_play_pressed() -> void:
	var tween = _fade_out(2)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Game/Levels/pvp/pvp.tscn")
	)