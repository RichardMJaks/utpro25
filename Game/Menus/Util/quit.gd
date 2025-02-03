extends Button

func _ready() -> void:
	if OS.has_feature("web"):
		hide()

func pressed():
	get_tree().quit()
