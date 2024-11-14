extends Control

@onready var vid: VideoStreamPlayer = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	vid.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
