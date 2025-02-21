extends RigidBody3D

var weapon_handler
var pick_up_animation : bool = false
var animation_done : bool = false
var animation_player : AnimationPlayer
var playing_animation
var original_bullet_count
@export var shader_despawn : float = 20.0
@export var shotgun_strength : float = 5.0
@export var bullet_count : int = 2

@onready var particle_manager : Node3D = $ParticleManager
@onready var shader_applier = $ShaderApplier
@onready var shell_holder = $"../../../../UserInterface/Shotgun UI/Shotgun Shell Holder"

signal pick_up

func _ready() -> void:
	weapon_handler = find_parent("WeaponHandling")
	animation_player = $"Gun Functions"
	
	original_bullet_count = bullet_count
	
func _process(_delta: float) -> void:
	bullet_count = clamp(bullet_count, 0, 2)


	

	
func _input(event: InputEvent) -> void:
	playing_animation = animation_player.is_playing()
	
	
	if event is InputEventMouseButton:
		if event.is_action_pressed("Left_Click") and weapon_handler and !playing_animation and visible and bullet_count > 0:
			animation_player.play("Shooting")
			particle_manager.shooting_particles()
			bullet_count -= 1
			
			shotgun_knockback()
			
			Global.camera_trauma.add_trauma(5.0, 0.8, 5.0)
			shell_holder.remove_shells(bullet_count)
	
			
	elif event is InputEventKey:
		if event.is_action_pressed("Reload") and weapon_handler and !playing_animation and visible and bullet_count != original_bullet_count:
			animation_player.play("Reloading")
			bullet_count = original_bullet_count
			shell_holder.add_shells(bullet_count)
	
	
func _on_pick_up() -> void:
	if !playing_animation:
		animation_player.play("Pickup")
		

		


		
func shotgun_knockback() -> void:
	var shotgun_direction = Global.player.camera_controller.global_transform.basis.z.normalized()
	var knockback = shotgun_direction * shotgun_strength
	
	Global.player.max_air_speed += 5
	Global.player.velocity += knockback
	Global.player.AirTimer.start()
	

	



	
