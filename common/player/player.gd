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
@export var health : int = 15
@export var health_bar : TextureProgressBar
var current_health = health

# References
@export_group("References")
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer2D = $sfx/sfx
@onready var gun: Sprite2D = $weapons/ak/gun
@export var sfx_footsteps : AudioStreamRandomizer
@onready var ak: Node2D = $weapons/ak
@onready var health_color_rect: ColorRect = $hud/ColorRect
@export var dust_particles: CPUParticles2D


var canSpawnParticle = true
var footsteps_frames : Array = [1,5]

func _ready() -> void:
	update_health_bar()
	update_health_color()

func _process(_delta: float) -> void:
	
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
		emit_dust_particles()
	else:
		velocity = velocity.move_toward(Vector2.ZERO, decel * delta)
		dust_particles.emitting = false

func emit_dust_particles() -> void:
	if not dust_particles.emitting:
		dust_particles.emitting = true

func take_damage(damage: int) -> void:
	current_health -= damage
	update_health_bar()
	if current_health <= 0:
		die()

func update_health_color() -> void:
	health_color_rect.color = Color(1.0, current_health, current_health)  # Red to green based on health

func update_health_bar() -> void:
	health_bar.max_value = health # Ensure the max_value is set
	health_bar.value = current_health
	update_health_color()

func die() -> void:
	queue_free()

func handle_animation() -> void:
	if velocity.length() > 0.0:
		sprite.play("run2")
	else:
		sprite.play("idle2")

func handle_tilt(_delta: float) -> void:
	var target_tilt = tilt_amount * velocity.x / speed
	self.rotation = lerp(self.rotation, target_tilt, 0.1)

func load_sfx(sfx_to_load):
	if sfx.stream != sfx_to_load:
		sfx.stop()
		
		sfx.stream = sfx_to_load

func _on_sprite_frame_changed() -> void:
	if sprite.animation == "idle2": return
	load_sfx(sfx_footsteps)
	if sprite.frame in footsteps_frames: sfx.play()
	if sprite.frame in footsteps_frames:
		sfx.play()
