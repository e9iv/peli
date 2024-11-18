extends Control
@onready var camera: Camera2D = $"../Camera2D"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#var tween = get_tree().create_tween()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#var tween = get_tree().create_tween()
	if Input.is_action_just_pressed("inventory"):
		#tween.tween_property(self, "modulate:a", 0, 0)
		#tween.tween_property(self, "modulate:a", 1, 1)
		self.visible = true
	if Input.is_action_just_released("inventory"):
		#tween.tween_property(self, "modulate:a", 0, 1)
		self.visible = false
