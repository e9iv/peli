extends Node2D

@onready var ak: Sprite2D = $Ak
@onready var cam: Camera2D = $"../Camera2D"
@onready var hit_sprite_scene : PackedScene = preload("res://scenes/blood.tscn")
@onready var gunshot: AudioStreamPlayer2D = $"../sfx/gunshot"
@onready var outofammo: AudioStreamPlayer2D = $"../sfx/outofammo"
@onready var ammo_bar: TextureProgressBar = $"../Control/TextureProgressBar"

@export var damage: int = 10
@export var range: float = 500.0

# Ammo-related variables
@export var max_ammo_in_clip = 30  # Maximum bullets in the clip
@export var total_ammo = 90        # Total reserve ammo
@export var current_clip = max_ammo_in_clip  # Ammo in the current clip
@export var is_reloading = false   # Whether the weapon is reloading

# Shooting cooldown
@export var cooldown = 0.5  # Time between shots
@export var last_shot_time = 0.0

var rng = RandomNumberGenerator.new()

func _ready():
	update_ammo_bar()

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	ak.look_at(mouse_pos)
	$RayCast2D.look_at(mouse_pos)
	if mouse_pos.x < position.x:
		$RayCast2D.position = Vector2(-6, 0)
		ak.position = Vector2(3, 2)
		ak.flip_v = true

	# Flip children
		for child in ak.get_children():
			child.flip_v = true
	elif mouse_pos.x > position.x:
		$RayCast2D.position = Vector2(6, 0)
		ak.position = Vector2(-3, 0)
		ak.flip_v = false
	 #Flip children$"."
		for child in ak.get_children():
			child.flip_v = false

func update_ammo_bar():
	# Update the TextureProgressBar to reflect current ammo
	ammo_bar.max_value = max_ammo_in_clip  # Ensure the max_value is set
	ammo_bar.value = current_clip

func shoot():
	if is_reloading:
		print("Can't shoot while reloading!")
		return

	if current_clip <= 0:
		print("Out of ammo! Reload to shoot.")
		outofammo.play()
		return

	if (Time.get_ticks_msec() / 250.0) - last_shot_time < cooldown:
		print("Cooldown in progress...")
		return

	# Perform shooting
	current_clip -= 1  # Reduce ammo in clip
	last_shot_time = Time.get_ticks_msec() / 250.0
	update_ammo_bar()
	print("Bang! Ammo left in clip:", current_clip)
	
	gunshot.play()

	# Get the RayCast2D node
	var raycast = $RayCast2D
	raycast.enabled = true

	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		var collider = raycast.get_collider()

		print("Hit at:", collision_point)  # Debug: Check if the point is valid

		# Apply damage to the collider
		if collider.has_method("take_damage"):
			collider.take_damage(damage)

		# Place hit effect at the collision point
		place_hit_sprite(collision_point)
		
		spawn_bullet_tracer(global_position, collision_point)
	else:
		print("No collision detected")  # Debug: Helps identify configuration issues

func reload():
	if is_reloading:
		print("Already reloading!")
		return

	if current_clip == max_ammo_in_clip:
		print("Clip is already full!")
		return

	if total_ammo <= 0:
		print("No reserve ammo left!")
		return

	is_reloading = true
	print("Reloading...")

	# Simulate reload delay
	await get_tree().create_timer(2.0).timeout # 2-second reload time

	var ammo_needed = max_ammo_in_clip - current_clip
	var ammo_to_reload = min(ammo_needed, total_ammo)

	current_clip += ammo_to_reload
	total_ammo -= ammo_to_reload

	is_reloading = false
	print("Reload complete! Ammo in clip:", current_clip, "Reserve ammo:", total_ammo)
	update_ammo_bar()

func spawn_bullet_tracer(start: Vector2, end: Vector2):
	var tracer = Line2D.new()
	tracer.width = .25  # Thickness of the tracer
	
	var gradient = Gradient.new()
	gradient.add_point(0.0, Color(1,1,0,1))  # Start: Yellow, fully opaque
	gradient.add_point(1.0, Color(1,1,0,0))
	
	tracer.add_point(start)
	tracer.add_point(end)

	var gradient_texture = GradientTexture2D.new()
	gradient_texture.gradient = gradient

	# Add the tracer to the scene
	get_tree().root.add_child(tracer)  # Add to root to avoid movement issues

	# Fade out and remove after 0.1 seconds
	var timer = Timer.new()
	timer.wait_time = 0.1
	timer.one_shot = true
	timer.connect("timeout", Callable(tracer, "queue_free"))
	tracer.add_child(timer)
	timer.start()

func draw_hit_effect(position: Vector2):
	# Create a small flash or particle effect at the hit point
	print("Hit at ", position)

func place_hit_sprite(position: Vector2):
	if hit_sprite_scene:
		var blood = hit_sprite_scene.instantiate()
		var my_random_number : int = rng.randf_range(1, 5)
		blood.global_position = position  # Set to global position
		get_tree().root.add_child(blood)  # Add to a static parent to avoid movement
		if blood is AnimatedSprite2D:
			match my_random_number:
				1:
					var number = "1"
					print(number)
					blood.play(number)
					blood.connect("animation_finished", Callable(blood, "queue_free"))
				2:
					var number = "2"
					print(number)
					blood.play(number)
					blood.connect("animation_finished", Callable(blood, "queue_free"))
				3:
					var number = "3"
					print(number)
					blood.play(number)
					blood.connect("animation_finished", Callable(blood, "queue_free"))
				4:
					var number = "4"
					print(number)
					blood.play(number)
					blood.connect("animation_finished", Callable(blood, "queue_free"))
				5:
					var number = "5"
					print(number)
					blood.play(number)
					blood.connect("animation_finished", Callable(blood, "queue_free"))

func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()
