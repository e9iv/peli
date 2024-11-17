extends CharacterBody2D

# Variables
@export_group("Speed Variables")
@export var speed: float = 50
@export var sprintspd: float = 85
@export_group("Dash Variables")
@export var dash_speed: float = 200
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0
@export_group("Accel & Decel")
@export var accel: float = 1000
@export var decel: float = 950
@export_group("Tilt Amount")
@export var tilt_amount: float = 0.1

@export var sfx_footsteps : AudioStreamRandomizer
@onready var dashsfx: AudioStreamPlayer2D = $sfx/dashsfx

# References
@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer2D = $sfx/sfx

# Variables for dash and movement
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO
var is_dashing: bool = false


var footsteps_frames : Array = [1,5]

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 0)
	tween.tween_property(self, "modulate:a", 1, 1)

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	#Flip sprite based on the mouse position
	if mouse_pos.x < position.x:
		sprite.flip_h = true
	elif mouse_pos.x > position.x:
		sprite.flip_h = false

func _physics_process(delta: float) -> void:
	# Handle dashing
	if is_dashing:
		velocity = dash_direction * dash_speed
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
	else:
		# Normal movement
		handle_movement(delta)

	# Cooldown logic
	if dash_cooldown_timer > 0.0:
		dash_cooldown_timer -= delta

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

	# Check for dash input
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0.0:
		start_dash(direction)
		load_sfx(sfx_footsteps)
		sfx.play()

func start_dash(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		is_dashing = true
		dashsfx.play()
		dash_timer = dash_duration
		dash_cooldown_timer = dash_cooldown
		dash_direction = direction

func handle_animation() -> void:
	if is_dashing:
		pass
	elif velocity.length() > 0.0:
		sprite.play("gun_run")
	else:
		sprite.play("gun_idle")


	# Flip sprite based on velocity direction
	if velocity.x < 0:
		sprite.flip_h = true
	elif velocity.x > 0:
		sprite.flip_h = false


func handle_tilt(delta: float) -> void:
	var target_tilt = tilt_amount * velocity.x / speed
	self.rotation = lerp(self.rotation, target_tilt, 0.1)

func load_sfx(sfx_to_load):
	if sfx.stream != sfx_to_load:
		sfx.stop()
		sfx.stream = sfx_to_load


func _on_sprite_frame_changed() -> void:
	if sprite.animation == "gun_idle": return
	load_sfx(sfx_footsteps)
	if sprite.frame in footsteps_frames: sfx.play()
