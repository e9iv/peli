extends CharacterBody2D

# Variables
@export var speed : float = 50 # Movement speed
@export var accel : float = 35
@export var decel : float = 25
@export var mouseSpd : float = 0.8
@export var sprintspd : float = 85
# References
@onready var sprite: AnimatedSprite2D = $Sprite2D

# _physics_process is called every physics frame (usually 60 FPS)
func _physics_process(delta):
	# Movement input
	var direction = Vector2.ZERO  # Initialize a zero vector
	var mouse_position = get_global_mouse_position()
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if sprite.animation != "run":
			sprite.play("run")
	else:
		if sprite.animation != "idle":
			sprite.play("idle")

	# Normalize direction vector to prevent diagonal speed boost
	direction = direction.normalized()

	if direction != Vector2.ZERO:
# Accelerate towards the input direction
		velocity = velocity.move_toward(direction * speed, accel * delta)
	else:
# Decelerate when no input is given
		velocity = velocity.move_toward(Vector2.ZERO, decel * delta)

	# Move the player using move_and_slide() (or move_and_collide in some cases)
	velocity = direction * speed
	move_and_slide()

	# Flip sprite based on movement direction
	if velocity.x < 0:  # Moving left
		sprite.flip_h = true
	elif velocity.x > 0:  # Moving right
		sprite.flip_h = false
