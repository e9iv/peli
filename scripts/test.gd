extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite_2d: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	print("Hello There!")
