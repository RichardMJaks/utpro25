extends Node

@export var dialogTextBox: Label
@export var darkFade: TextureRect
@export_file("*.tscn") var gameScene: String

class DialogLine:
	var type: String
	var text: String

	@warning_ignore("shadowed_variable")	
	func _init(type: String, text: String):
		self.type = type
		self.text = text

var dialogLines: Array[DialogLine] = [
	DialogLine.new("narrator", "Leiger, Linda ja Vanapagan hakkasid Hiiumaalt Saaremaale kive loopima."),
	DialogLine.new("narrator", "Sina oled Suur Tõll, ja Suur Tõll asja niisama ei jäta."),
	DialogLine.new("narrator", "Viska kivi tagasi ja anna neile õppetund!"),
]
var dialogLineIndex: int = 0

var state = "fade_in" # fade_in, write, wait, fade_out
var timeElapsed: float = 0

var fadeTime: float = 1.5
var dialogWaitTime: float = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeElapsed += delta
	if (Input.is_action_just_pressed("ui_accept")):
		timeElapsed += 1000000 # Skips current state
	
	if (state == "fade_in"): fadeIn()
	if (state == "write"): write()
	if (state == "wait"): wait()
	if (state == "fade_out"): fadeOut()

func fadeIn():
	var fade: float = (fadeTime - timeElapsed) / fadeTime
	darkFade.modulate = Color(1, 1, 1, fade)
	
	if (timeElapsed > fadeTime):
		state = "write"
		timeElapsed = 0

func write():
	var line: String = dialogLines[dialogLineIndex].text
	@warning_ignore("narrowing_conversion")
	var targetChar: int = timeElapsed * 25
	
	if (targetChar > line.length()):
		targetChar = line.length()
		state = "wait"
		timeElapsed = 0
	
	dialogTextBox.text = line.substr(0, targetChar)

func wait():
	if (timeElapsed > dialogWaitTime):
		dialogLineIndex += 1
		if (dialogLineIndex >= dialogLines.size()):
			state = "fade_out"
		else:
			state = "write"
		timeElapsed = 0

func fadeOut():
	var fade: float = (timeElapsed) / fadeTime
	darkFade.modulate = Color(1, 1, 1, fade)
	
	if (timeElapsed > fadeTime):
		get_tree().change_scene_to_file(gameScene)
