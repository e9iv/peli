class_name Bullet
extends CharacterBody2D

@onready var player_hitbox = $PlayerHitbox

@export var initial_speed = 240.0
@export var target_speed = 240.0
@export var accel = 0.0
@export var lifespan = 1.0

var speed = initial_speed
var direction = Vector2.RIGHT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2.RIGHT.rotated(global_rotation)
	
	if player_hitbox:
		player_hitbox.area_entered.connect(_on_hitbox_area_entered)
	
	await get_tree().create_timer(lifespan).timeout
	await _before_lifespan_expired()
	queue_free()

func _physics_process(delta):
	speed = lerp(speed, target_speed, accel * delta)
	velocity = direction * speed * delta
	
	var collision = move_and_collide(velocity)
	if collision:
		queue_free()

func _before_lifespan_expired():
	pass

func _on_hitbox_area_entered(area: Area2D):
	pass
