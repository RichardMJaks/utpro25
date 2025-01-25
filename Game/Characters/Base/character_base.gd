extends CharacterBody2D
class_name Character

@warning_ignore("enum_variable_without_default")
var side: PlayerVars.SIDE

var is_throwing: bool = false
var volleyball: Volleyball = null

@onready var input_handler: InputHandler = %InputHandler

@onready var animator: AnimationPlayer = %Animator

@onready var top_throw_position: Marker2D = %TopThrowPosition
@onready var front_throw_position: Marker2D = %FrontThrowPosition

var throw_areas: Array[bool] = [false, false]

func _ready() -> void:
	# Sets Throwboxes orientation right, calls deferred to recieve side first
	(func(): %CatchAreas.scale.x = side).call_deferred()

func _physics_process(delta: float) -> void:
	# If throwing then all movement is blocked
	if is_throwing:
		velocity = Vector2.ZERO
		return

	# Check if any throw area is available to throw a ball
	if true not in throw_areas:
		volleyball = null

	if input_handler.wants_bounce and volleyball:
		_throw(volleyball)

	
	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * PlayerVars.gravity_multiplier * delta
	
	velocity.x = input_handler.dir * PlayerVars.speed

	move_and_slide()

func _throw(vb: Volleyball) -> void:
	vb.make_invisible()
	print("throwing")
	is_throwing = true
	if throw_areas[0]:
		animator.play("top_throw")
	else:
		animator.play("front_throw")

func top_throw() -> void:
	var vb_pos = top_throw_position.global_position
	var dir = PlayerVars.top_throw_dir
	dir.x = dir.x * side 

	do_throw(vb_pos, dir)

func front_throw() -> void:
	var vb_pos = front_throw_position.global_position
	var dir = PlayerVars.front_throw_dir 
	dir.x = dir.x * side

	do_throw(vb_pos, dir)

func do_throw(pos: Vector2, dir: Vector2) -> void:
	volleyball.make_visible()
	
	volleyball.global_position = pos
	volleyball.linear_velocity = dir * PlayerVars.bounce_force	

	print(name + " is throwing with " + str(dir))
	is_throwing = false

func _on_throw_area_entered(area: Area2D, i: int) -> void:
	volleyball = area.owner
	throw_areas[i] = true

func _on_throw_area_exited(_area: Area2D, i: int) -> void:
	throw_areas[i] = false
