extends Camera2D

const MAX_DISTANCE : float = 15

var target_distance : float = 0
var center_pos = position

@onready var camera: Camera2D = $"."


func _process(delta: float) -> void:
	var direction = center_pos.direction_to(get_local_mouse_position())
	var target_pos = center_pos + direction * target_distance
	
	target_pos = target_pos.clamp(
		center_pos - Vector2(MAX_DISTANCE, MAX_DISTANCE),
		center_pos + Vector2(MAX_DISTANCE, MAX_DISTANCE)
	)
	
	position = target_pos
	

func shake_camera():
	camera.offset = Vector2(randf() * 10 - 5, randf() * 10 - 5)  # Random shake
	await get_tree().create_timer(0.1).timeout
	camera.offset = Vector2.ZERO  # Reset

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		target_distance = center_pos.distance_to(get_local_mouse_position()) / 2
