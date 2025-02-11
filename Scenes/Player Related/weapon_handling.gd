extends Control

@onready var shotgun_preload = preload("res://Scenes/Guns/Shotgun/shotgun_weapon.tscn")
@export var gun_impulse : float = 2.0

var raycast
var instance_place
var shotgun
var viewport
var current_weapon : int
var equipped : bool = false
var first_equip : bool = false
var original_rotation : Vector3
var mouse_motion : float
var mouse_rot : Vector3
var rot_input : float = 0.0
var tilt_input : float = 0.0
var tilt_motion : float

func _ready() -> void:
	instance_place = get_node(".").find_parent("Main")
	shotgun = $"Container/SubViewport/Shotgun Weapon"
	viewport = $Container/SubViewport
	raycast = $"../ControllerCamera/Camera3D/RayCast3D"
	original_rotation = shotgun.rotation_degrees
	


func _unhandled_input(event: InputEvent) -> void:


	if event is InputEventMouseMotion:
		rot_input = -event.relative.x * Global.player.mouse_sensitivity
		tilt_input = (-event.relative.y * Global.player.mouse_sensitivity) * 2.5
		
		mouse_rot.z += tilt_input * Global.player.mouse_sensitivity
		mouse_rot.y += rot_input * Global.player.mouse_sensitivity
	
func _process(delta: float) -> void:
	mouse_motion = Global.player.rotation_input * 5.0
	tilt_motion = Global.player.tilt_input * 5.0
	
	shotgun_sway()
	
	

	

	

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		pickup_weapons()
		
	if Input.is_action_just_pressed("Drop Gun"):
		drop_weapons()
	
	
	if event is InputEventKey:
		weapon_selection()
		
	

	
	


	
		
func weapon_selection() -> void:
	if Input.is_action_just_pressed("Slot1") and equipped:
		current_weapon = 1
		shotgun.emit_signal("pick_up")
		
		
	elif Input.is_action_just_pressed("Slot2") and equipped:
		current_weapon = 2
	
	if equipped:
		if current_weapon == 1:
			shotgun.visible = true
		elif current_weapon == 2:
			shotgun.visible = false
	else:
		shotgun.visible = false



func pickup_weapons() -> void:
	if raycast.is_colliding() and raycast.get_collider().is_in_group("Shotgun"): #Raycast detection on an Area3D to determine when the player can pick up.
			shotgun.visible = true
			equipped = true
			shotgun.emit_signal("pick_up")
			
			
			raycast.get_collider().get_parent().queue_free() #Deletes the object when picked up.

			
			
			
func drop_weapons() -> void:
	if equipped and shotgun.visible: # If visible and player wants to drop, instance a new object at a fixed area.
		shotgun.visible = false
		equipped = false
		var drop_pos = $"../WeaponDropPos"
		
		var weapon_position = drop_pos.global_transform.origin
		
		var instance_weapon = shotgun_preload.instantiate()
		instance_place.add_child(instance_weapon)
		
		instance_weapon.global_transform.origin = weapon_position
		instance_weapon.global_transform.basis = drop_pos.basis
		instance_weapon.rotation = Global.player.rotation + Vector3(0, 83.25, 0)
		
		instance_weapon.apply_central_impulse(-Global.player.transform.basis.z * gun_impulse)
		
func shotgun_sway() -> void:
	var sway_weight : float = 15.0
	var sway_x = Vector3.ZERO
	
	
	if abs(mouse_motion) > 0.2 or abs(tilt_motion) > 0.2:
		sway_x = sway_x.lerp(mouse_rot, sway_weight)
		shotgun.rotation_degrees = sway_x + original_rotation
	elif abs(mouse_motion) < 0.2 or abs(tilt_motion) < 0.2:
		sway_x = sway_x.lerp(Vector3.ZERO, sway_weight)
		shotgun.rotation_degrees = sway_x + original_rotation
		mouse_rot.y = 0.0
		mouse_rot.z = 0.0

	
