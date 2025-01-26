extends HSlider

@export var audio_bus: String
var bus_index: int

func _ready():
	bus_index = AudioServer.get_bus_index(audio_bus)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

@warning_ignore("shadowed_variable_base_class")
func on_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
