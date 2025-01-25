extends CharacterBody2D
class_name Player

var volleyball: RigidBody2D = null

@onready var hit_buffer: Timer = %HitBuffer
var hb_active: bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var gravity = get_gravity().y * 3
	velocity.y += gravity * delta 

	var dir = Input.get_axis("m_left", "m_right")
	velocity.x = dir * PlayerVars.speed	

	if Input.is_action_just_pressed("m_jump") and is_on_floor():
		velocity.y = -PlayerVars.jump_force

	if Input.is_action_just_pressed("a_bounce"):
		hit_buffer.start()
		hb_active = true

	if hb_active and volleyball:
		_bounce(volleyball)
		hb_active = false

	move_and_slide()

# Bounces the ball in a certain direction, while keeping its speed	
func _bounce(vb: RigidBody2D) -> void:
	var vb_speed: float = vb.linear_velocity.length()
	var dir: Vector2 = (vb.global_position - global_position).normalized()
	vb.linear_velocity = PlayerVars.bounce_force * dir

func _on_recieve_area_entered(body:Node2D) -> void:
	volleyball = body.owner

func _on_recieve_area_exited(_body:Node2D) -> void:
	volleyball = null


func _on_hit_buffer_timeout() -> void:
	hb_active = false
