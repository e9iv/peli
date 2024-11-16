extends Node2D

@onready var ak: Sprite2D = $Ak
@onready var cam: Camera2D = $"../Camera2D"
@onready var hit_sprite_scene : PackedScene = preload("res://scenes/blood.tscn")

@export var damage: int = 10
@export var range: float = 500.0

var cooldown: float = 0.5
var last_shot_time: float = -1.0

var rng = RandomNumberGenerator.new()

func _ready():
	pass

func _process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	ak.look_at(mouse_pos)
	$RayCast2D.look_at(mouse_pos)
	if mouse_pos.x < position.x:
		ak.position = Vector2(3, 2)
		$RayCast2D.position = Vector2(-6, 0)
		ak.flip_v = true
	# Flip children
		for child in ak.get_children():
			child.flip_v = true
	elif mouse_pos.x > position.x:
		ak.position = Vector2(-3, 0)
		$RayCast2D.position = Vector2(6, 0)
		ak.flip_v = false
	# Flip children
		for child in ak.get_children():
			child.flip_v = false

func shoot():
	if (Time.get_ticks_msec() / 1000.0) - last_shot_time < cooldown:
		return  # Prevent shooting during cooldown

	last_shot_time = Time.get_ticks_msec() / 1000.0

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
	else:
		print("No collision detected")  # Debug: Helps identify configuration issues


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
