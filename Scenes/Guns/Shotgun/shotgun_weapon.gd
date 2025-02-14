extends RigidBody3D

var weapon_handler
var pick_up_animation : bool = false
var animation_done : bool = false
var animation_player : AnimationPlayer
var shader_despawn : float = 20.0
@onready var shader_applier = $ShaderApplier
@export var shotgun_strength : float = 5.0


signal pick_up

func _ready() -> void:
	weapon_handler = find_parent("WeaponHandling")
	animation_player = $AnimationPlayer
	
	
	
func _process(delta: float) -> void:
	pass


	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("Left_Click") and weapon_handler and visible and !animation_player.is_playing():
			$AnimationPlayer.play("Shooting")
			shotgun_knockback()
		
			
	
			
	elif event is InputEventKey:
		if event.is_action_pressed("Reload") and weapon_handler and visible and !animation_player.is_playing():
			$AnimationPlayer.play("Reloading")


	
	
func _on_pick_up() -> void:
	if !animation_player.is_playing():
		$AnimationPlayer.play("Pickup")
		


		
func shotgun_knockback() -> void:
	var shotgun_direction = Global.player.camera_controller.global_transform.basis.z.normalized()
	var knockback = shotgun_direction * shotgun_strength
	
	Global.player.max_air_speed = 30.0
	Global.player.velocity += knockback
	
	



	
