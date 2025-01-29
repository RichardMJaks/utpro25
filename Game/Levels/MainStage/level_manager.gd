extends Node
class_name LevelManager

@export var next_screen: String = "res://Game/StoryScenes/win_screen.tscn"


var ps_volleyball: PackedScene = preload("res://Game/Volleyball/volleyball.tscn")
var ps_stuck_vb: PackedScene = preload("res://Game/Volleyball/stuck_ball.tscn")
@export var ps_player_1: PackedScene = preload("res://Game/Characters/Player/player.tscn")
@export var ps_player_2: PackedScene = preload("res://Game/Characters/BasicAI/basic_ai.tscn")

var left_health: int = PlayerVars.total_health
var right_health: int = PlayerVars.total_health

var player_1: Character
var player_2: Character

var volleyball: Volleyball
var winner: PlayerVars.SIDE = PlayerVars.SIDE.NONE

@onready var player_1_pos: Marker2D = %Player1Position
@onready var player_2_pos: Marker2D = %Player2Position

@onready var vb_1_pos: Marker2D = %VolleyballP1Position
@onready var vb_2_pos: Marker2D = %VolleyballP2Position

@export var player_starts: bool = false
@export var is_pvp: bool = false

# Transitioner
@export var transition: Control
@export var dialog_box: DialogBox

# Audio
@onready var a_hit_land: AudioStreamPlayer = %HitLand
@onready var a_hit_water: AudioStreamPlayer = %HitWater

# AI Helpers
@onready var midpoint: Marker2D = %ArenaMidpointHelper
@onready var island_midpoint: Marker2D = %IslandMidpointHelper


func _ready() -> void:
	left_health = PlayerVars.total_health
	right_health = PlayerVars.total_health

	player_1 = ps_player_1.instantiate()
	player_1.side = PlayerVars.SIDE.LEFT
	add_child(player_1)

	player_2 = ps_player_2.instantiate()
	player_2.side = PlayerVars.SIDE.RIGHT	
	add_child(player_2)

	_reset_player_positions()
	var t = %Fader.create_tween()

	t.tween_property(%Fader, "color:a", 0, 2).set_ease(Tween.EASE_IN)
	if dialog_box:
		t.tween_callback(func(): get_tree().create_timer(1).timeout.connect(func(): 
			dialog_box.visible = true
			dialog_box.process_mode = Node.PROCESS_MODE_ALWAYS
			))
		
		dialog_box.finished.connect(_initialize_game)
	else:
		t.tween_callback(func(): get_tree().create_timer(1).timeout.connect(_initialize_game))

func _check_collision(body: CollisionObject2D) -> void:
	if not (body is Ground):
		return
	
	a_hit_land.play()
	_create_stuck_ball(volleyball, ps_stuck_vb)
		
	_reduce_health(body.side)
	SignalBus.landed.emit()

func _create_stuck_ball(vb: Volleyball, ps: PackedScene) -> void:
	var pos = vb.global_position
	var stuck_vb = ps.instantiate()
	add_child(stuck_vb, true)

	vb.queue_free()
	stuck_vb.global_position = pos	

func _reduce_health(id: PlayerVars.SIDE) -> void:
	match(id):
		PlayerVars.SIDE.LEFT:
			left_health -= 1
		PlayerVars.SIDE.RIGHT:
			right_health -= 1

	# Win
	if right_health <= 0:
		winner = PlayerVars.SIDE.LEFT
		if is_pvp:
			_show_who_won()
			return
		get_tree().create_timer(3, true, false, true) \
			.timeout.connect(do_transition)
		get_tree().paused = true
		return
	# Lose
	if left_health <= 0:
		winner = PlayerVars.SIDE.RIGHT
		get_tree().paused = true
		if not is_pvp:
			_show_game_over()
		else:
			_show_who_won()
		return
	
	%Crickets.playing = true
	_initialize_game()	

func _show_game_over() -> void:
	%GameOver.visible = true

func _show_who_won() -> void:
	%WhichWon.set_win_text(winner)
	%WhichWon.visible = true

func do_transition() -> void:
	var t = %Fader.create_tween()
	t.tween_property(%Fader, "color:a", 1, 2).set_ease(Tween.EASE_OUT)
	
	t.tween_callback(
		func():
			get_tree().paused = false
			get_tree().change_scene_to_file(next_screen)
	)

func _initialize_game() -> void:
	if dialog_box:
		dialog_box.visible = false
		dialog_box.process_mode = Node.PROCESS_MODE_DISABLED

	get_tree().paused = true
	get_tree().create_timer(3, true, false, true) \
		.timeout.connect(
		func(): 
			get_tree().paused = false
			%Crickets.playing = false
			SignalBus.game_continued.emit()

	)
	_reset_player_positions()
	volleyball = _spawn_volleyball(ps_volleyball)
	
	# Set Ball Start Position
	player_starts = !player_starts
	if player_starts:
		volleyball.global_position = vb_1_pos.global_position
	else:
		volleyball.global_position = vb_2_pos.global_position

func _reset_player_positions() -> void:
	player_1.global_position = player_1_pos.global_position
	player_2.global_position = player_2_pos.global_position
	player_1.animator.play("idle")
	player_2.animator.play("idle")

func _spawn_volleyball(ps: PackedScene) -> Volleyball:
	var vb = ps.instantiate()
	vb.body_entered.connect(_check_collision)
	add_child(vb, true)

	vb.linear_velocity = Vector2.UP * 1000
	
	return vb

func _on_try_again() -> void:
	var t = %Fader.create_tween()
	t.tween_property(%Fader, "color:a", 1, 2).set_ease(Tween.EASE_OUT)
	
	t.tween_callback(
		func():
			get_tree().reload_current_scene()

	)


func _on_return_to_menu() -> void:
	get_tree().change_scene_to_file("res://Game/Menus/main_menu.tscn")
