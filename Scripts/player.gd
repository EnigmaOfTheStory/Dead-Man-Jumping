extends CharacterBody2D


const SPEED = 200.0
const SHIFT_SPEED = 100.0
const JUMP_VELOCITY = -335.0

@onready var CoyoteTimer = SceneTreeTimer
@onready var CoyoteActive = false
@onready var CoyoteDuration = 0.15
var ON_GROUND = false
var checkpoint_manager

	
func _physics_process(delta: float) -> void:
		
	if Input.is_action_pressed("Rise"):
		position.y -= 18
		
	if not is_on_floor() and ON_GROUND:	
		CoyoteTimer = get_tree().create_timer(CoyoteDuration, false, true)
		CoyoteTimer.timeout.connect(CoyoteTimeUp.bind())
		CoyoteActive = true
		ON_GROUND = false



	elif is_on_floor():
		ON_GROUND = true

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or CoyoteActive):
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 10)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	print(velocity)
		
	move_and_slide()
	
func _on_hit_box_body_entered(_body):
	_kill_player()
		
func CoyoteTimeUp():
	CoyoteActive = false
	
func _kill_player():
	checkpoint_manager = get_parent().get_node("CheckpointManager")
	global_position = checkpoint_manager.last_location
