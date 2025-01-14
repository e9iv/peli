extends Node2D

var MAIN = preload("res://common/main/main.tscn")
@onready var video : VideoStreamPlayer = $CanvasLayer/VideoStreamPlayer

func _ready() -> void:
	video.play()

	video.finished.connect(self._on_video_finished)

func _on_video_finished():
	# Change to the next scene
	get_tree().change_scene_to_packed(MAIN)
