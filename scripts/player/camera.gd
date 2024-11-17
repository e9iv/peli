extends Camera2D

const MAX_DISTANCE : float = 15

var target_distance : float = 0
var center_pos = position

var shake_amount : float = 0
var default_offset : Vector2 = offset
var pos_x : int
var pos_y : int

@onready var camera: Camera2D = $"."
@onready var timer: Timer = $Timer
@onready var tween : Tween = create_tween()

func _ready() -> void:
	set_process(true)
	Global.camera = self
	randomize()

func _process(delta: float) -> void:
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	
	if InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2
	
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	
	position = target_pos
	
	offset = Vector2(randf_range(-1, 1) * shake_amount, randf_range(-1, 1) * shake_amount)

func shake(time: float, amount: float):
		timer.wait_time = time
		shake_amount = amount
		set_process(true)
		timer.start()


func shake_camera():
	camera.offset = Vector2(randf() * 10 - 5, randf() * 10 - 5)  # Random shake
	await get_tree().create_timer(0.1).timeout
	camera.offset = Vector2.ZERO  # Reset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2

func _on_timer_timeout() -> void:
	set_process(false)
	tween.interpolate_value(self, "offset", 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
