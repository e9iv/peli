extends Bullet

@onready var sprite_group = $spritegroup

func _ready() -> void:
	super._ready()
	
	var tween = get_tree().create_tween()
	tween.tween_property(
		sprite_group,
		"scale",
		Vector2.ZERO,
		lifespan / 4
	).set_delay(
		3 * lifespan / 4
	)
