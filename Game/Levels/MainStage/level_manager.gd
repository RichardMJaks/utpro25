extends Node
class_name LevelManager

@export var next_screen: String = "res://Game/StoryScenes/win_screen.tscn"

#region PackedScenes
var ps_volleyball: PackedScene = preload("res://Game/Volleyball/volleyball.tscn")
var ps_stuck_vb: PackedScene = preload("res://Game/Volleyball/stuck_ball.tscn")
@export var ps_player_1: PackedScene = preload("res://Game/Characters/Player/player.tscn")
@export var ps_player_2: PackedScene = preload("res://Game/Characters/BasicAI/basic_ai.tscn")
@export var p1_script: Script
@export var p2_script: Script
@export var p2_ai_values: Resource
#endregion

#region Node References
var player_1: Character
var player_2: Character

var volleyball: Volleyball

@onready var tree: SceneTree = get_tree()

@onready var player_1_pos: Marker2D = %Player1Position
@onready var player_2_pos: Marker2D = %Player2Position

@onready var vb_1_pos: Marker2D = %VolleyballP1Position
@onready var vb_2_pos: Marker2D = %VolleyballP2Position

# UI
@onready var fader: Control = %Fader
@export var dialog_box: DialogBox
#endreigon

# Audio
@onready var a_hit_land: AudioStreamPlayer = %HitLand
@onready var a_hit_water: AudioStreamPlayer = %HitWater
@onready var a_crickets: AudioStreamPlayer = %Crickets

# AI Helpers
@onready var midpoint: Marker2D = %ArenaMidpointHelper
@onready var island_midpoint: Marker2D = %IslandMidpointHelper
#endregion

#region Game variables
var winner: PlayerVars.SIDE = PlayerVars.SIDE.NONE
var left_health: int = PlayerVars.total_health
var right_health: int = PlayerVars.total_health
@export var player_starts: bool = false
@export var is_pvp: bool = false
#endregion

#region Visuals
var fade_time: float = 2
var post_fade_delay: float = 1
#endregion

func _ready() -> void:
	tree.paused = true
	_initialize_players()
	_reset_player_positions()

	var fade: Tween = _fade_in(fade_time)
	fade.tween_callback(_start_level.bind(post_fade_delay))

#region Level initialization
func _initialize_players() -> void:
	left_health = PlayerVars.total_health
	right_health = PlayerVars.total_health

	player_1 = ps_player_1.instantiate()
	player_1.side = PlayerVars.SIDE.LEFT
	add_child(player_1)

	player_2 = ps_player_2.instantiate()
	player_2.side = PlayerVars.SIDE.RIGHT
	if not is_pvp:
		player_2.is_ai = true
	player_2.set_behaviour_script(p2_script, p2_ai_values)	
	add_child(player_2)

func _start_level(delay: float) -> void:
	var next_action_timer: SceneTreeTimer = \
		tree.create_timer(delay, true, false, true)
	
	if dialog_box:
		next_action_timer.timeout.connect(
			func():
				dialog_box.visible = true
				dialog_box.process_mode = Node.PROCESS_MODE_ALWAYS
		)
		dialog_box.finished.connect(_start_game)
	else:
		next_action_timer.timeout.connect(_start_game)

func _start_game() -> void:
	if dialog_box:
		dialog_box.visible = false
		dialog_box.process_mode = Node.PROCESS_MODE_DISABLED

	tree.create_timer(3, true, false, true).timeout.connect(
		func(): 
			tree.paused = false
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
#endregion

#region Fading tweens
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
#endregion

#region Game runtime handling
func _reduce_health(id: PlayerVars.SIDE) -> void:
	tree.paused = true
	match(id):
		PlayerVars.SIDE.LEFT:
			left_health -= 1
		PlayerVars.SIDE.RIGHT:
			right_health -= 1
	
	_check_health()
	
func _check_health() -> void:
	if left_health <= 0:
		_handle_win(PlayerVars.SIDE.RIGHT)
		return
	if right_health <= 0:
		_handle_win(PlayerVars.SIDE.LEFT)
		return
	
	a_crickets.play()
	_start_game()
	
func _handle_win(winning_side: PlayerVars.SIDE) -> void:
	winner = winning_side

	if is_pvp:
		_show_who_won()
		return
	
	if winner == PlayerVars.SIDE.LEFT:
		var fade: Tween = _fade_out(fade_time)
		fade.tween_callback(_switch_to_scene.bind(next_screen))
	if winner == PlayerVars.SIDE.RIGHT:
		_show_game_over()
#endregion

#region UI
func _show_who_won() -> void:
	%WhichWon.visible = true
	%WhichWon.set_win_text(winner)
	tree.paused = true

func _show_game_over() -> void:
	tree.paused = true
	%GameOver.visible = true
#endregion


func _switch_to_scene(scene_path: String) -> void:
	tree.paused = false
	tree.change_scene_to_file(scene_path)

#region Ball
func _check_collision(body: CollisionObject2D) -> void:
	if not (body is Ground):
		return
	
	a_hit_land.play()
	_create_stuck_ball(ps_stuck_vb)
		
	_reduce_health(body.side)
	SignalBus.landed.emit()

func _create_stuck_ball(ps: PackedScene) -> void:
	var pos = volleyball.global_position
	var stuck_vb = ps.instantiate()
	add_child(stuck_vb, true)

	volleyball.queue_free()
	volleyball = null
	stuck_vb.global_position = pos	


func _spawn_volleyball(ps: PackedScene) -> Volleyball:
	var vb = ps.instantiate()
	vb.body_entered.connect(_check_collision)
	add_child(vb, true)

	vb.linear_velocity = Vector2.UP * 1000
	
	return vb
#endregion

#region Menu Actions
func _on_try_again() -> void:
	var t = %Fader.create_tween()
	t.tween_property(%Fader, "color:a", 1, 2).set_ease(Tween.EASE_OUT)
	
	t.tween_callback(
		func():
			get_tree().reload_current_scene()

	)

func _on_return_to_menu() -> void:
	get_tree().change_scene_to_file("res://Game/Menus/main_menu.tscn")
#endregion