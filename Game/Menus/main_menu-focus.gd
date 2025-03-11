extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	%Play.grab_focus()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("got input")