extends CharacterBody2D

var player
var enemy
var speed
var direction
var distance
var spawn

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn = self.global_position
	player = get_parent().get_parent().get_node("Player")
	speed = 45
	enemy = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	direction = (enemy.global_position - player.global_position).normalized()
	distance = (enemy.global_position - player.global_position).length()
	if distance <= 350:
		velocity = speed * -direction
	else:
		velocity = 0 * -direction
	#print(direction)
	
	move_and_slide()


func player_death():
	global_position = spawn
