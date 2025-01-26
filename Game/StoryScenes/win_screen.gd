extends Node

@export var darkFade: TextureRect
@export_file("*.tscn") var gameScene: String

var state = "fade_in" # fade_in, idk
var timeElapsed: float = 0

var fadeTime: float = 1.2
var waitTime: float = 1.5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timeElapsed += delta
	
	if (state == "fade_in"): fadeIn()

func fadeIn():
	var fade: float = (fadeTime - timeElapsed) / fadeTime
	print((fadeTime - timeElapsed))
	print(fadeTime)
	print((fadeTime - timeElapsed) / fadeTime)
	darkFade.modulate = Color(1, 1, 1, fade)
	
	if (timeElapsed > fadeTime):
		state = "wait"
		timeElapsed = 0
