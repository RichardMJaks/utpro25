extends Control

func set_win_text(winner: PlayerVars.SIDE) -> void:
	%Wintext.text = ["Mängija 1", "Ei keegi", "Mängija 2"][1 - winner] + " võitis!"
