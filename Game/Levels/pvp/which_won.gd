extends Control

func _ready() -> void:
	visibility_changed.connect(%Uuesti.grab_focus)

func set_win_text(winner: PlayerVars.SIDE) -> void:
	%Wintext.text = ["Mängija 1", "Ei keegi", "Mängija 2"][1 - winner] + " võitis!"
