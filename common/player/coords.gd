extends Label
@onready var player: CharacterBody2D = $"../.."



func _process(delta):
	# Update the coordinates dynamically (replace with your logic)

	# Format the text to show coordinates
	text = "Coords: (%.2f, %.2f)" % [player.position.x, player.position.y]

	# Change color based on coordinate values
	if player.position.x >= 0 and player.position.y >= 0:
		modulate = Color(0, 1, 0) # Green for both positive
	elif player.position.x < 0 and player.position.y < 0:
		modulate = Color(1, 0, 0) # Red for both negative
	else:
		modulate = Color(1, 1, 0) # Yellow for mixed signs
