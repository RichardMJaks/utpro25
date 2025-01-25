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

@export var rethrow_delay: float = 1
var throw_blocked: bool = false

var throw_areas: Array[bool] = [false, false]

func _ready() -> void:
	# Sets Throwboxes orientation right, calls deferred to recieve side first
	(
		func(): 
			for child in %CatchAreas.get_children():
				child.position.x = side * child.position.x
				%Sprite.flip_h = side == PlayerVars.SIDE.RIGHT
	).call_deferred()

func _physics_process(delta: float) -> void:
	# If throwing then all movement is blocked
	if is_throwing:
		velocity = Vector2.ZERO
		return

	# Check if any throw area is available to throw a ball
	if true not in throw_areas:
		volleyball = null

	if velocity.x != 0 and animator.has_animation("walk"):
		animator.play("walk")

	if velocity.x == 0 and animator.has_animation("idle"):
		animator.play("idle")

	if input_handler.wants_bounce and volleyball:
		input_handler.wants_bounce = false
		_throw(volleyball)

	
	# Gravity
	if not is_on_floor():
		velocity.y += get_gravity().y * PlayerVars.gravity_multiplier * delta
	
	velocity.x = input_handler.dir * PlayerVars.speed

	move_and_slide()

func _throw(vb: Volleyball) -> void:
	if vb.is_queued_for_deletion():
		return

	is_throwing = true
	if throw_areas[0]:
		vb.make_invisible()
		animator.play("top_throw")
	elif throw_areas[1]:
		vb.make_invisible()
		animator.play("front_throw")
	else:
		is_throwing = false

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

	volleyball = null

	if name != "Player":
		is_throwing = false

func _stop_throwing() -> void:
	is_throwing = false

func _create_throw_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = rethrow_delay
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(
		func():
			throw_blocked = false
			timer.queue_free()
	)
	return add_child(timer)

func _on_throw_area_entered(area: Area2D, i: int, s: String) -> void:
	if not (name == "Player"):
		print(str(i) + " | " + s)
	volleyball = area.owner
	if not (true in throw_areas):
		throw_areas[i] = true

func _on_throw_area_exited(_area: Area2D, i: int) -> void:
	throw_areas[i] = false
