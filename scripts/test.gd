extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var text: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.play("default")
	interaction_area.interact = Callable(self, "_on_interact")

func _on_interact():
	text.visible = true
	await get_tree().create_timer(1.0).timeout
	text.visible = false
