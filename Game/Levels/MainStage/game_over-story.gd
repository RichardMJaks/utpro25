extends Control


func _ready() -> void:
	visibility_changed.connect(%TryAgain.grab_focus)
