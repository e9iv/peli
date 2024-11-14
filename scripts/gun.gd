extends Node2D

@onready var ak: Sprite2D = $ak
@onready var p_sprite: Sprite2D = $"../Sprite2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	
	ak.look_at(mouse_position)
