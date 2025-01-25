extends Node
class_name LevelManager

var left_health: int
var right_health: int

var ps_volleyball: PackedScene = preload("res://Game/Volleyball/volleyball.tscn")
var ps_player: PackedScene = preload("res://Game/Characters/Player/player.tscn")
var ps_basic: PackedScene = preload("res://Game/Characters/BasicAI/basic_ai.tscn")

var player_1: Character
var player_2: Character #TODO: Set correct typehint once enemies are designed 

var volleyball: Volleyball

@onready var player_1_pos: Marker2D = %Player1Position
@onready var player_2_pos: Marker2D = %Player2Position

@onready var vb_1_pos: Marker2D = %VolleyballP1Position
@onready var vb_2_pos: Marker2D = %VolleyballP2Position

func _ready() -> void:
	left_health = PlayerVars.total_health
	right_health = PlayerVars.total_health

	SignalBus.landed.connect(_reduce_health)

	#TODO: Move anything beyond this comment to _initialize_game after testing is done
	if ps_player:
		player_1 = ps_player.instantiate()
		add_child(player_1)
		player_1.global_position = player_1_pos.global_position
		player_1.side = PlayerVars.SIDE.LEFT
	
	if ps_volleyball:
		volleyball = ps_volleyball.instantiate()
		add_child(volleyball)
		volleyball.global_position = vb_1_pos.global_position
		volleyball.body_entered.connect(_check_collision)

	if ps_basic:
		player_2 = ps_basic.instantiate()
		add_child(player_2)
		player_2.global_position = player_2_pos.global_position
		player_2.side = PlayerVars.SIDE.RIGHT

func _check_collision(body: CollisionObject2D) -> void:
	if not (body is Ground):
		return
	print(body.side)
	# Uncomment it later	
	# _reduce_health(body.side)

func _reduce_health(id: PlayerVars.SIDE) -> void:
	print("Removing health from " + PlayerVars.SIDE.keys()[id])
	match(id):
		PlayerVars.SIDE.LEFT:
			left_health -= 1
		PlayerVars.SIDE.RIGHT:
			right_health -= 1

	_initialize_game()	

func _initialize_game() -> void:
	pass
