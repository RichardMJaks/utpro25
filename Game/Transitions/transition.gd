extends Control

@export var fader: TextureRect
@onready var shader: ShaderMaterial = fader.material
@export var fade_time: float = 5
@export var transition_on_ready: bool = true

var b_fade_in: bool = false
var b_fade_out: bool = false

var t: float = 0

signal finished_in()
signal finished_out()

func fade_in(time: float) -> void:
	shader.set_shader_parameter("fade", 0.0)
	b_fade_in = true
	t = 0
	fade_time = time

func fade_out(time: float) -> void:
	shader.set_shader_parameter("fade", 1.0)
	b_fade_out = true
	t = 0
	fade_time = time

func _ready() -> void:
	if transition_on_ready:
		fade_in(fade_time)

func _process(delta: float) -> void:
	if b_fade_in:
		t = clampf(t + delta * 1 / fade_time, 0, 1)
		shader.set_shader_parameter(
			"fade", 
			lerpf(
				shader.get_shader_parameter("fade"), 1.0, t
			)
		)
		if t >= 1:
			finished_in.emit()
			b_fade_in = false
	
	if b_fade_out:
		t = clampf(t + delta * 1 / fade_time, 0, 1)
		shader.set_shader_parameter(
			"fade", 
			lerpf(
				shader.get_shader_parameter("fade"), 0.0, t
			)
		)
		if t >= 1:
			finished_out.emit()
			b_fade_out = false
