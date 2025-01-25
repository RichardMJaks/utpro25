extends Node

class DialogLine:
	var type: String
	var text: String
	
	func _init(type: String, text: String):
		self.type = type
		self.text = text

var dialogLines: Array[DialogLine] = [
	DialogLine.new("narrator", "Hiiumaal pesitsev Leiger hakkas Saaremaale kive loopima."),
	DialogLine.new("narrator", "Sina oled Suur Tõll, ja Suur Tõll asja niisama ei jäta."),
	DialogLine.new("narrator", "Viska kivi tavasi ja anna Leigerile õppetund!"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
