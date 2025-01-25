extends CharacterBody2D
class_name Character

@warning_ignore("enum_variable_without_default")
var side: PlayerVars.SIDE

var is_throwing: bool = false
var volleyball: Volleyball = null

@onready var input_handler: InputHandler = %InputHandler

@onready var animator_top: AnimationPlayer = %TopAnimator
@onready var animator_bottom: AnimationPlayer = %BottomAnimator

@onready var top_throw_position: Marker2D = %TopThrowPosition
@onready var front_throw_position: Marker2D = %BottomThrowPosition

func _physics_process(delta: float) -> void:
	if input_handler.wants_bounce and volleyball:
		_throw(volleyball)

	# If throwing then all movement is blocked
	if is_throwing:
		velocity = Vector2.ZERO
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * PlayerVars.gravity_multiplier * delta
	
	velocity.x = input_handler.dir

	if input_handler.wants_jump and is_on_floor():
		velocity.y = PlayerVars.jump_force
	
	move_and_slide()

func _throw(vb: Volleyball) -> void:
	is_throwing = true
	vb.make_invisible()

func top_throw() -> void:
	volleyball.make_visible()
	volleyball.global_position = top_throw_position.global_position

	var dir = PlayerVars.top_throw_dir * side
	volleyball.linear_velocity = dir * PlayerVars.bounce_force

	is_throwing = false

func front_throw() -> void:
	volleyball.make_visible()
	volleyball.global_position = front_throw_position.global_position

	var dir = PlayerVars.front_throw_dir * side
	volleyball.linear_velocity = dir * PlayerVars.bounce_force




