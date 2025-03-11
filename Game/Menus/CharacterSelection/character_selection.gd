extends Control

@onready var fader: ColorRect = %Fader

@onready var display_p1: TextureRect = %CharP1
@onready var display_p2: TextureRect = %CharP2

var display_p1_tween: Tween = null
var display_p2_tween: Tween = null

@export var character_textures: Dictionary[MPVars.CHARACTER, Texture2D]

func _ready() -> void:
	%Fader.visible = true
	_fade_in(2)
	%Play.grab_focus()

func set_player_1(character: MPVars.CHARACTER) -> void:
	if display_p1_tween:
		display_p1_tween.kill()
	MPVars.p1_character = character
	display_p1.texture = character_textures[character]
	display_p1_tween = tween_display(display_p1)


func set_player_2(character: MPVars.CHARACTER) -> void:
	if display_p2_tween:
		display_p2_tween.kill()
	MPVars.p2_character = character
	display_p2.texture = character_textures[character]
	display_p2_tween = tween_display(display_p2)

func tween_display(display: TextureRect) -> Tween:
	display.material.set("shader_parameter/offset", 1.0)
	var tween: Tween = display.create_tween()
	tween.tween_property(display, "material:shader_parameter/offset", 0.0, 0.2)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	return tween

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

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"ui_continue"):
		_on_play_pressed()
	if Input.is_action_just_pressed(&"ui_return"):
		get_tree().change_scene_to_file("res://Game/Menus/main_menu.tscn")

func _on_play_pressed() -> void:
	var tween = _fade_out(2)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Game/Levels/pvp/pvp.tscn")
	)