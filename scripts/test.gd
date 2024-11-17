extends Node2D

@onready var interaction_area: InteractionArea = $InteractionArea
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var text: Label = $Label
@onready var label_2: Label = $Label2
@onready var ouch: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var hello: AudioStreamPlayer2D = $"AudioStreamPlayer2D2"

@export var health : int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite_2d.play("default")
	interaction_area.interact = Callable(self, "_on_interact")

func take_damage(amount: int):
	label_2.visible = true
	ouch.play()
	Global.camera.shake(0.3,2)
	health -= amount
	if health <= 0:
		die()
		label_2.visible = false

func die():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate", Color.RED, 1)
	tween.tween_property(self, "modulate:a", 0, 1)
	await tween.finished
	await ouch.finished
	queue_free()

func _on_interact():
	text.visible = true
	hello.play()
	await get_tree().create_timer(1.0).timeout
	text.visible = false
