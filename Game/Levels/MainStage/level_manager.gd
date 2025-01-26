extends Node
class_name LevelManager

@export var next_screen: NodePath = "res://Game/StoryScenes/win_screen.tscn"

var left_health: int = PlayerVars.total_health
var right_health: int = PlayerVars.total_health

var ps_volleyball: PackedScene = preload("res://Game/Volleyball/volleyball.tscn")
var ps_stuck_vb: PackedScene = preload("res://Game/Volleyball/stuck_ball.tscn")
@export var ps_player_1: PackedScene = preload("res://Game/Characters/Player/player.tscn")
@export var ps_player_2: PackedScene = preload("res://Game/Characters/BasicAI/basic_ai.tscn")

var player_1: Character
var player_2: Character

var volleyball: Volleyball

@onready var player_1_pos: Marker2D = %Player1Position
@onready var player_2_pos: Marker2D = %Player2Position

@onready var vb_1_pos: Marker2D = %VolleyballP1Position
@onready var vb_2_pos: Marker2D = %VolleyballP2Position

var player_starts: bool = false

# AI Helpers
@onready var midpoint: Marker2D = %ArenaMidpointHelper
@onready var island_midpoint: Marker2D = %IslandMidpointHelper


func _ready() -> void:
	left_health = PlayerVars.total_health
	right_health = PlayerVars.total_health

	SignalBus.landed.connect(_reduce_health)

	player_1 = ps_player_1.instantiate()
	player_1.side = PlayerVars.SIDE.LEFT

	player_2 = ps_player_2.instantiate()
	player_2.side = PlayerVars.SIDE.RIGHT	

	_initialize_game()
	add_child(player_2)
	add_child(player_1)

func _check_collision(body: CollisionObject2D) -> void:
	if not (body is Ground):
		return
	
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
	print("Removing health from " + PlayerVars.SIDE.keys()[id])
	match(id):
		PlayerVars.SIDE.LEFT:
			left_health -= 1
		PlayerVars.SIDE.RIGHT:
			right_health -= 1

	# Win
	if right_health <= 0:
		get_tree().create_timer(3, true, false, true) \
			.timeout.connect(
			func(): 
				get_tree().paused = false
				get_tree().change_scene_to_file(next_screen)
		)
		get_tree().paused = true
		return
	# Lose
	if left_health <= 0:
		pass
	
	get_tree().paused = true
	_initialize_game()	

	get_tree().create_timer(3, true, false, true) \
		.timeout.connect(func(): get_tree().paused = false)

func _initialize_game() -> void:
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

func _spawn_volleyball(ps: PackedScene) -> Volleyball:
	var vb = ps.instantiate()
	vb.body_entered.connect(_check_collision)
	add_child(vb, true)
	
	return vb
	
		
