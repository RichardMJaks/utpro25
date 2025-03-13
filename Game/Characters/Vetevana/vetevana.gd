extends AnimatedSprite2D

@export var anim: AnimationPlayer

func throw(dir: float) -> void:
    flip_h = dir == 1
    anim.play("default")

func served() -> void:
    SignalBus.served.emit()