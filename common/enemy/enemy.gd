extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

# Variables
@export var speed: float = 20.0  # Movement speed
var player: Node2D = null  # Reference to the player
var direction: Vector2 = Vector2.ZERO  # Movement direction
var health : int = 100

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	queue_free()

# Movement logic
func _physics_process(delta: float) -> void:
	player = get_tree().get_nodes_in_group("player")[0]  # Ensure the player is in the "Player" group
	if player:
		# Chase the player
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	
	sprite.flip_h = direction.x < 0
