extends Camera2D

var shaking: bool = false
var strength: float = 0
var initial_strength = 0
var duration: float = 0
var t: float = 0

func _ready() -> void:
	SignalBus.landed.connect(_landed)
	SignalBus.bounced.connect(_bounced)

func _landed() -> void:
	shake(50, 1)

func _bounced() -> void:
	shake(10, 0.05)

func _process(delta: float) -> void:
	if t >= 1:
		offset = Vector2.ZERO
		shaking = false
		initial_strength = 0
	
	if not shaking:
		return
	
	var dir = Vector2.from_angle(randf() * 10)
	offset = dir * strength
	
	t += delta * (1 / duration) 
	strength = lerpf(strength, 0, t)

@warning_ignore("shadowed_variable")
func shake(strength : float, duration: float) -> void:
	self.strength = strength
	self.duration = duration
	shaking = true
	t = 0
	initial_strength = strength
