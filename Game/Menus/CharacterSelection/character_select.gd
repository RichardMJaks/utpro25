extends VBoxContainer

signal changed(character: MPVars.CHARACTER)

@export var device: int = 0
@export var active_modulate: Color = Color.WHITE
@export var inactive_modulate: Color = Color.DARK_GRAY
var PREFIX: Array[String] = ["p1_", "p2_"]

var current: int = -1
@onready var selections := get_children()

func _ready() -> void:
    for selection: TextureRect in selections:
        selection.modulate = inactive_modulate
    
func switch_active(dir: int) -> MPVars.CHARACTER:
    if current == 0 and dir < 0:
        return -1
    if current + 1 == selections.size() and dir > 0:
        return -1
    
    selections[current].modulate = inactive_modulate
    current += dir
    selections[current].modulate = active_modulate
    return selections[current].character

func _process(_delta: float) -> void:
    # This is a small hack to avoid the race condition
    if current == -1:
        current = 0
        changed.emit(switch_active(0))
    var dir = 0
    if Input.is_action_just_pressed(PREFIX[device] + "up"): dir = -1
    if Input.is_action_just_pressed(PREFIX[device] + "down"): dir = 1
    if not dir: return
        
    var character = switch_active(dir)
    if character == -1: return

    changed.emit(character)



