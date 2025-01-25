extends Node
class_name LevelManager

var left_health: int
var right_health: int

var ps_volleyball: PackedScene = preload("res://Game/Volleyball/volleyball.tscn")
var ps_player: PackedScene = preload("res://Game/Characters/Player/player.tscn")

var player_1: Character
var player_2: Character #TODO: Set correct typehint once enemies are designed 

@onready var player_1_pos: Marker2D = %Player1Position
@onready var player_2_pos: Marker2D = %Player2Position

func _ready() -> void:
	left_health = PlayerVars.total_health
	right_health = PlayerVars.total_health

	SignalBus.landed.connect(_reduce_health)

	if ps_player:
		player_1 = ps_player.instantiate()
		player_1.global_position = player_1_pos.global_position
		player_1.side = PlayerVars.SIDE.LEFT	

func _reduce_health(id: PlayerVars.SIDE) -> void:
	match(id):
		PlayerVars.SIDE.LEFT:
			left_health -= 1
		PlayerVars.SIDE.RIGHT:
			right_health -= 1

	_initialize_game()	

func _initialize_game() -> void:
	pass
