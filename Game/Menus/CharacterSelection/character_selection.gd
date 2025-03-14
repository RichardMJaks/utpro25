extends Control

@onready var fader: ColorRect = %Fader

@onready var display_p1: TextureRect = %CharP1
@onready var display_p2: TextureRect = %CharP2

var display_p1_tween: Tween = null
var display_p2_tween: Tween = null

var p1_locked: bool = false
var p2_locked: bool = false

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

func p1_lock() -> void:
	p1_locked = true
	lock_display_tween(display_p1)

func p2_lock() -> void:
	p2_locked = true
	lock_display_tween(display_p2)

func tween_display(display: TextureRect) -> Tween:
	display.material.set("shader_parameter/offset", 1.0)
	var tween: Tween = display.create_tween()
	tween.tween_property(display, "material:shader_parameter/offset", 0.0, 0.2)\
		.set_ease(Tween.EASE_OUT)\
		.set_trans(Tween.TRANS_CUBIC)
	return tween

func lock_display_tween(display: TextureRect) -> Tween:
	print("Locking")
	display.material.set("shader_parameter/brightness", 1.0)
	display.material.set("shader_parameter/flashing", 1.0)
	var tween = display.create_tween()
	tween.tween_property(display, "material:shader_parameter/flashing", 0.0, 0.5)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_OUT)\
		.set_delay(0.2)
	#tween.tween_method(lock_tween_method.bind(display), 0.0, 1.0, 0.3).set_ease(Tween.EASE_OUT)

	return tween

func lock_tween_method(value: float, display: TextureRect) -> void:
	print("tweening value: " + str(value))
	var freq: float = 1.0
	var ampl: float = 1.0
	
	var result: float = ampl * sin(freq * value * PI)
	print(result)
	display.material.set("shader_parameter/flashing", result)

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
	if p1_locked and p2_locked:
		_on_play_pressed()
	if Input.is_action_just_pressed(&"ui_return"):
		get_tree().change_scene_to_file("res://Game/Menus/main_menu.tscn")

func _on_play_pressed() -> void:
	var tween = _fade_out(2)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind("res://Game/Levels/load_stuff-pvp.tscn")
	)