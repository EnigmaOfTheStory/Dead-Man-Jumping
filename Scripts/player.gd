extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -335.0

@onready var CoyoteTimer = SceneTreeTimer
@onready var CoyoteActive = false
@onready var CoyoteDuration = 0.15
@onready var player = self
var ON_GROUND = false
var bounceable = false
var checkpoint_manager
var closestDistance
var closestEnemy
var SlowTime = false
signal player_death



func find_closest_enemy() -> Object:
	closestDistance = 10000000000
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	for enemy in all_enemies:
		var enemy_distance = position.distance_to(enemy.position)
		if enemy_distance < closestDistance:
			closestDistance = enemy_distance
			closestEnemy = enemy
		
	return closestEnemy

func _ready():
	closestEnemy = find_closest_enemy()
	#print(closestEnemy)	
	
func _physics_process(delta: float) -> void:
		
		
	if not is_on_floor() and ON_GROUND:	
		CoyoteTimer = get_tree().create_timer(CoyoteDuration, false, true)
		CoyoteTimer.timeout.connect(CoyoteTimeUp.bind())
		CoyoteActive = true
		ON_GROUND = false
	
	elif is_on_floor():
		ON_GROUND = true

	# Add the gravity.
	if not is_on_floor() and (velocity.y <= 650 or (velocity.y <= 65 and SlowTime == true)):
		if SlowTime == false:
			velocity += get_gravity() * delta * 0.75
		else:
			velocity += get_gravity() * delta * 0.075

	# Handle jump.
	if Input.is_action_just_pressed("Jump") and (is_on_floor() or CoyoteActive or bounceable):
		velocity.y = JUMP_VELOCITY
		if bounceable and !is_on_floor():
			velocity.y += JUMP_VELOCITY / 3
			velocity += 150 * (-(closestEnemy.global_position - player.global_position).normalized())

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		if SlowTime == false:
			velocity.x = move_toward(velocity.x, direction * SPEED, SPEED / 10)
		else:
			velocity.x = move_toward(velocity.x, direction * SPEED / 3, SPEED / 30)
	else:
		if SlowTime == false:
			velocity.x = move_toward(velocity.x, 0, SPEED/ 5)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED/ 15)
	
	#print(bounceable)
	#print(velocity)
	print(SlowTime)
	
	move_and_slide()

func _on_slow_box_body_entered(_body):
	SlowTime = true
	velocity.y /= 15
	
func _on_slow_box_body_exited(_body):
	SlowTime = false
	
func _on_hit_box_body_entered(_body):
	_kill_player()

func _on_bounce_box_body_entered(_body):
	bounceable = true
		
func _on_bounce_box_body_exited(_body):
	bounceable = false
		
func CoyoteTimeUp():
	CoyoteActive = false
	
func _kill_player():
	emit_signal("player_death")
	checkpoint_manager = get_parent().get_node("CheckpointManager")
	global_position = checkpoint_manager.last_location
	velocity.x = 0
	velocity.y = 0
	
