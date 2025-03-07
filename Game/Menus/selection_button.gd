extends TextureButton

signal custom_button_pressed(character: MPVars.CHARACTER)
@export var character: MPVars.CHARACTER

func _pressed() -> void:
	custom_button_pressed.emit(character)

func _process(delta: float) -> void:
	if is_hovered():
		modulate = Color.WHITE
	else:
		modulate = Color.LIGHT_GRAY