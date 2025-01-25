extends CharacterBody2D
class_name Character

@warning_ignore("enum_variable_without_default")
var side: PlayerVars.SIDE

var is_throwing: bool = false
var volleyball: Volleyball = null

@onready var input_handler: InputHandler = %InputHandler

@onready var animator: AnimationPlayer = %Animator

@onready var top_throw_position: Marker2D = %TopThrowPosition
@onready var front_throw_position: Marker2D = %BottomThrowPosition

var throw_areas: Array[bool] = [false, false]

func _physics_process(delta: float) -> void:
	# Check if any throw area is available to throw a ball
	if true not in throw_areas:
		volleyball = null

	if input_handler.wants_bounce and volleyball:
		_throw(volleyball)

	# If throwing then all movement is blocked
	if is_throwing:
		velocity = Vector2.ZERO
		return
	
	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * PlayerVars.gravity_multiplier * delta
	
	velocity.x = input_handler.dir * PlayerVars.speed

	move_and_slide()

func _throw(vb: Volleyball) -> void:
	is_throwing = true
	if throw_areas[0]:
		animator.play("top_throw")
	else:
		animator.play("front_throw")
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

func _on_throw_area_entered(area: Area2D, i: int) -> void:
	volleyball = area.owner
	throw_areas[i] = true

func _on_throw_area_exited(area: Area2D, i: int) -> void:
	throw_areas[i] = false