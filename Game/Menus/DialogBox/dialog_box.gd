extends Control
class_name DialogBox

@export var time_per_letter: float = 0.05

signal finished()
enum TALKER {P1, P2}

class DialogLine:
	var type: TALKER
	var text: String

	@warning_ignore("shadowed_variable")	
	func _init(type: TALKER, text: String):
		self.type = type
		self.text = text

var lines: Array[DialogLine] = []
var current_line_idx: int = -1
var current_line: DialogLine = null
var current_tween: Tween = null

var enabled_modulate: Color = Color.WHITE
var disabled_modulate: Color = Color.DARK_GRAY

var line_finished: bool = false

func _ready() -> void:
	add_lines()
	type_line()

# Overwrite this with super()
func add_lines(arr: Array[Array] = []) -> void:
	for line in arr:
		lines.append(DialogLine.new(line[0], line[1]))


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"ui_accept"):
		if line_finished:
			type_line()
		else:
			reveal_text()

func type_line() -> void:
	current_line = next_line()
	if current_line == null:
		finished.emit()
		return
	
	line_finished = false
	current_tween = create_tween()

	var chars = current_line.text.length() 
	var tween_time = chars * time_per_letter

	match current_line.type:
		TALKER.P1:
			%TextBox.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
			%P1Texture.modulate = enabled_modulate
			%P2Texture.modulate = disabled_modulate
		TALKER.P2:
			%TextBox.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
			%P1Texture.modulate = disabled_modulate
			%P2Texture.modulate = enabled_modulate
	
	%TextBox.visible_ratio = 0
	%TextBox.text = current_line.text

	current_tween.tween_property(%TextBox, "visible_ratio", 1, tween_time).set_trans(Tween.TRANS_LINEAR)
	current_tween.tween_callback(reveal_text)

func reveal_text() -> void:
	if current_tween:
		current_tween.kill()
	%TextBox.visible_ratio = 1
	line_finished = true

func next_line() -> DialogLine:
	if current_line_idx >= (lines.size() - 1):
		return null
	current_line_idx += 1
	return lines[current_line_idx]
