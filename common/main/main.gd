extends Node2D

@onready var video: VideoStreamPlayer = $intro/CanvasLayer/VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	get_tree().paused = true
	video.play()
	video.finished.connect(self._on_video_finished)
	tween.tween_property(self, "modulate", Color.WHITE, 2.5)
	tween.tween_property(self, "modulate:a", 1, 5)
	
func _on_video_finished():
	get_tree().paused = false
