extends Control

@onready var inventory_open: AudioStreamPlayer = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("inventory"):
		inventory_open.play()
		self.visible = true
		
	if Input.is_action_just_released("inventory"):
		self.visible = false
