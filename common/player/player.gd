extends CharacterBody2D

# Variables
@export_group("Speed Variables")
@export var speed: float = 50
@export var sprintspd: float = 85
@export_group("Accel & Decel")
@export var accel: float = 1000
@export var decel: float = 950
@export_group("Tilt Amount")
@export var tilt_amount: float = 0.1
@export_group("Health Variables")
@export var health : int = 25
@export var health_bar : TextureProgressBar
var current_health = health

# References
@export_group("References")
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer2D = $sfx/sfx
@onready var gun: Sprite2D = $weapons/ak/gun
@export var sfx_footsteps : AudioStreamRandomizer
@onready var ak: Node2D = $weapons/ak


var footsteps_frames : Array = [1,5]

func _ready() -> void:
	update_health_bar()

func _process(delta: float) -> void:
	
	if Global.is_reloading == true:
		return
	else:
		var mouse_pos = get_global_mouse_position()
		ak.look_at(mouse_pos)
		if mouse_pos.x < position.x - 1:
			sprite.flip_h = true
			gun.position = Vector2(-3, -2)
			gun.flip_v = true
			for child in gun.get_children():
				child.flip_v = true
		elif mouse_pos.x > position.x + 1:
			sprite.flip_h = false
			gun.position = Vector2(-3, 0)
			gun.flip_v = false
			for child in gun.get_children():
				child.flip_v = false
func _physics_process(delta: float) -> void:
	# Normal movement
	handle_movement(delta)

	
	# Apply velocity and move
	move_and_slide()

	# Update animations and tilt
	handle_animation()
	handle_tilt(delta)

func handle_movement(delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO

	# Get input for movement
	if Input.is_action_pressed("right"):
		direction.x += 1
	if Input.is_action_pressed("left"):
		direction.x -= 1
	if Input.is_action_pressed("down"):
		direction.y += 1
	if Input.is_action_pressed("up"):
		direction.y -= 1

	# Normalize direction and calculate velocity
	direction = direction.normalized()
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, accel * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decel * delta)

func update_health_bar():
	health_bar.max_value = health # Ensure the max_value is set
	health_bar.value = current_health

func handle_animation() -> void:
	if velocity.length() > 0.0:
		sprite.play("run")
	else:
		sprite.play("idle")

func handle_tilt(delta: float) -> void:
	var target_tilt = tilt_amount * velocity.x / speed
	self.rotation = lerp(self.rotation, target_tilt, 0.1)

func load_sfx(sfx_to_load):
	if sfx.stream != sfx_to_load:
		sfx.stop()
		
		sfx.stream = sfx_to_load

func _on_sprite_frame_changed() -> void:
	if sprite.animation == "idle": return
	load_sfx(sfx_footsteps)
	if sprite.frame in footsteps_frames: sfx.play()
