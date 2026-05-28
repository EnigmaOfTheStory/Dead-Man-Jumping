extends CharacterBody2D

var player
var enemy
var speed
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_parent().get_node("Player")
	speed = 30
	enemy = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	direction = (enemy.global_position - player.global_position).normalized()
	velocity = speed * -direction
	#print(direction)
	
	
	
	
	
	move_and_slide()
