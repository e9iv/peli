extends Gun

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("reload"):
		reload()
