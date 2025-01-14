extends Label

const MIN_FPS = 0
const MAX_FPS = 60

func _process(delta):
	# Get the current FPS
	var fps = Engine.get_frames_per_second()
	text = "fps: %d" % fps

	# Calculate the percentage of performance
	var percentage = clamp((fps - MIN_FPS) / float(MAX_FPS - MIN_FPS) * 100.0, 0, 100)
	
	# Update the text to include the percentage

	# Smoothly interpolate color based on percentage
	# Green (100%) -> Yellow (50%) -> Red (0%)
	if percentage > 50:
		# Interpolate from yellow to green
		var t = (percentage - 50) / 50.0
		modulate = Color(1 - t, 1, 0)
	else:
		# Interpolate from red to yellow
		var t = percentage / 50.0
		modulate = Color(1, t, 0)
