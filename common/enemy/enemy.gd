extends CharacterBody2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_timer: Timer = $AttackTimer

# Variables
@export var speed: float = 20.0  # Movement speed
@export var attack_range: float = 50.0  # Attack range
@export var attack_damage: int = 5  # Attack damage
@export var attack_cooldown: float = 1.0  # Attack cooldown in seconds
var player: Node2D = null  # Reference to the player
var direction: Vector2 = Vector2.ZERO  # Movement direction
var health: int = 10

func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]  # Ensure the player is in the "Player" group
	if attack_timer:
		attack_timer.wait_time = attack_cooldown
		attack_timer.connect("timeout", Callable(self, "_on_attack_timer_timeout"))

func _process(_delta: float) -> void:
	if health <= 0:
		GameManager.money += 1.0
		queue_free()

# Movement logic
func _physics_process(_delta: float) -> void:
	if player:
		# Chase the player
		direction = (player.global_position - global_position).normalized()
		velocity = direction * speed

		# Check if within attack range
		if global_position.distance_to(player.global_position) <= attack_range and attack_timer and attack_timer.is_stopped():
			attack_timer.start()
	else:
		velocity = Vector2.ZERO

	move_and_slide()
	sprite.flip_h = direction.x < 0

func _on_hit_box_area_entered(hitbox: HitBox) -> void:
	health -= hitbox.damage
	GameManager.money += hitbox.damage / 10.0
	print("Z-Health:", health)

func _on_attack_timer_timeout() -> void:
	if player and global_position.distance_to(player.global_position) <= attack_range:
		player.call("take_damage", attack_damage)
		print("Enemy attacked the player!")
	attack_timer.stop()
