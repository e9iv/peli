extends Camera2D

const MAX_DISTANCE : float = 15

var target_distance : float = 0
var center_pos = position

var target_zoom: Vector2 = Vector2(4.5, 4.5)  # Default zoom
var zoom_speed: float = 5.0  # Speed at which the zoom happens

var shake_amount : float = 0
var default_offset : Vector2 = offset
var pos_x : int
var pos_y : int

@onready var camera: Camera2D = $"."
@onready var timer: Timer = $Timer
@onready var tween : Tween = get_tree().create_tween()

func _ready() -> void:
	Global.camera = self
	randomize()
	zoom = target_zoom

func _process(delta: float) -> void:
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	
	zoom = zoom.lerp(target_zoom, zoom_speed * delta)
	
	if InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2
	
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	
	position = target_pos
	
	if shake_amount > 0:
		offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)
	else:
		offset = default_offset
	return

func shake(time: float, amount: float):
		timer.wait_time = time
		shake_amount = amount
		timer.start()

func _on_timer_timeout() -> void:
	shake_amount = 0
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("zoomin"):
		target_zoom = Vector2(1.5, 1.5)  # Set target zoom to 1.5xwa
	elif Input.is_action_just_pressed("zoomout"):
		target_zoom = Vector2(10.0, 10.0)
	else:
		target_zoom = Vector2(4.5, 4.5)  # Set target zoom to 4.5x
