extends Control

@onready var try_again_func: Callable = owner._on_try_again
@onready var return_to_menu_func: Callable = owner._on_return_to_menu

func _ready() -> void:
	visibility_changed.connect(%Uuesti.grab_focus)

func set_win_text(winner: PlayerVars.SIDE) -> void:
	%Wintext.text = ["Mängija 1", "Ei keegi", "Mängija 2"][1 - winner] + " võitis!"

func _process(_delta: float) -> void:
	if not visible:
		return

	if Input.is_action_just_pressed(&"ui_try-again"):
		try_again_func.call()
	
	if Input.is_action_just_pressed(&"ui_return-to-menu"):
		return_to_menu_func.call()