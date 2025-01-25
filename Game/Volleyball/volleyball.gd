extends RigidBody2D
class_name Volleyball

func _ready() -> void:
    body_entered.connect(_on_hit_ground)

func _on_hit_ground(ground: Ground) -> void:
    var side: PlayerVars.SIDE = ground.side
    SignalBus.landed.emit(side)

func make_invisible() -> void:
    freeze = true
    visible = false

func make_visible() -> void:
    freeze = false
    visible = true