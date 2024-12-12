class_name Gun
extends Node2D

@export_group("Bullet variables")
@export var bullet: PackedScene
@export var bullet_count : int = 1
@export var barrel_origin: Node2D
@export_group("Weapon Behavior")
@export_range(0, 360) var arc : float = 0
@export_range(0, 20) var fire_rate : float = 2.0

@export_group("Visuals")
@export var ammo_bar: TextureProgressBar
@export var anim: AnimationPlayer

@export_group("Sounds")
@export var fire_sound : AudioStreamPlayer2D
@export var reload_sound : AudioStreamPlayer2D
@export var out_of_ammo : AudioStreamPlayer2D

@export_group("Ammo variables")
@export var full_mag : int  # Maximum bullets in the clip
@export var reserve_ammo : int       # Total reserve ammo

@export_group("Camera Shake Values")
@export var duration : float
@export var intensity : float

var current_ammo_in_mag = full_mag  # Ammo in the current clip
var can_shoot = true

func _ready():
	update_ammo_bar()
	Global.is_reloading = false

func shoot():
	if Global.is_reloading == true:
		can_shoot = false
		return "Can't shoot while reloading!"
	if current_ammo_in_mag <= 0:
		reload()
		return
	if can_shoot:
		can_shoot = false
		for i in bullet_count:
			var new_bullet = bullet.instantiate()
			new_bullet.position = barrel_origin.global_position if barrel_origin else global_rotation
			
			if bullet_count == 1:
				new_bullet.rotation = global_rotation
			else:
				var arc_rad = deg_to_rad(arc)
				var increment = arc_rad / (bullet_count - 1)
				new_bullet.global_rotation = (
					global_rotation +
					increment * i -
					arc_rad / 2
				)
			get_tree().root.call_deferred("add_child", new_bullet)
			fire_sound.play()
			anim.play("muzzleflash")
			Global.camera.shake(duration, intensity)
			current_ammo_in_mag -= 1
			update_ammo_bar()
			print(current_ammo_in_mag)
		await get_tree().create_timer(1 / fire_rate).timeout
		can_shoot = true

func reload():
	if Global.is_reloading == true:
		can_shoot = false
		return "Already reloading"

	if current_ammo_in_mag == full_mag:
		return "Clip is already full!"

	if reserve_ammo <= 0:
		return "No reserve ammo left!"

	Global.is_reloading = true
	reload_sound.play()
	anim.play("reload")
	print("Reloading...")

	# Simulate reload delay
	await get_tree().create_timer(2.6).timeout # 2-second reload time

	var ammo_needed = full_mag - current_ammo_in_mag
	var ammo_to_reload = min(ammo_needed, reserve_ammo)

	current_ammo_in_mag += ammo_to_reload
	reserve_ammo -= ammo_to_reload

	Global.is_reloading = false
	print("Reload complete! Ammo in clip:", current_ammo_in_mag, "Reserve ammo:", reserve_ammo)
	update_ammo_bar()
	
	can_shoot = true

func update_ammo_bar():
	# Update the TextureProgressBar to reflect current ammo
	ammo_bar.max_value = full_mag  # Ensure the max_value is set
	ammo_bar.value = current_ammo_in_mag
