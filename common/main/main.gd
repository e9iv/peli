extends Node2D

@onready var video: VideoStreamPlayer = $intro/CanvasLayer/VideoStreamPlayer

@export var zombie : PackedScene

var current_wave : int

var starting_nodes : int
var current_nodes : int
var wave_spawn_ended

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = get_tree().create_tween()
	get_tree().paused = true
	video.play()
	video.finished.connect(self._on_video_finished)
	tween.tween_property(self, "modulate", Color.WHITE, 2.5)
	tween.tween_property(self, "modulate:a", 1, 5)
	current_wave = 0
	GameManager.current_wave = current_wave
	starting_nodes = get_child_count()
	current_nodes = get_child_count()
	position_to_next_wave()

func _process(delta: float) -> void:
	current_nodes = get_child_count()
	if wave_spawn_ended:
		position_to_next_wave()

func position_to_next_wave():
	if current_nodes == starting_nodes:
		if current_wave != 0:
			GameManager.moving_to_next_wave = true
		wave_spawn_ended = true
		current_wave += 1
		GameManager.current_wave = current_wave
		prepare_spawn("zombies", 4.0, 4.0)
		print(current_wave)

func prepare_spawn(type, multiplier, mob_spawns):
	var mob_amount = float(current_wave) * multiplier
	var mob_wait_time : float = 2.0
	print("mob_amount: ", mob_amount)
	var mob_spawn_rounds = mob_amount / mob_spawns
	spawn_type(type, mob_spawn_rounds, mob_wait_time)

func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	if type == "zombies":
		var spawn1 = $spawners/spawner1
		var spawn2 = $spawners/spawner2
		var spawn3 = $spawners/spawner3
		var spawn4 = $spawners/spawner4
		if mob_spawn_rounds >= 1:
			for i in mob_spawn_rounds:
				var zombie1 = zombie.instantiate()
				zombie1.global_position = spawn1.global_position
				var zombie2 = zombie.instantiate()
				zombie2.global_position = spawn2.global_position
				var zombie3 = zombie.instantiate()
				zombie3.global_position = spawn3.global_position
				var zombie4 = zombie.instantiate()
				zombie4.global_position = spawn4.global_position
				add_child(zombie1)
				add_child(zombie2)
				add_child(zombie3)
				add_child(zombie4)
				mob_spawn_rounds -= 1
				await get_tree().create_timer(mob_wait_time).timeout
		wave_spawn_ended = true

func _on_video_finished():
	get_tree().paused = false
