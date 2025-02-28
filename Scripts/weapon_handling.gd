extends Node3D

@onready var shotgun_preload = preload("res://Scenes/Guns/Shotgun/shotgun_spawn.tscn")
@export var gun_impulse : float = 2.0


var raycast
var instance_place
var shotgun
var viewport
var current_weapon : int
var equipped : bool = false
var first_equip : bool = false
var shotgun_position
@onready var viewport_shader = $"Shotgun Weapon/ViewportShader"
@onready var shotgun_ui = $"../../../UserInterface/Shotgun UI"

func _ready() -> void:
	shotgun = $"Shotgun Weapon"
	raycast = $"../RayCast3D"
	shotgun_position = shotgun.rotation_degrees
	instance_place = get_tree().get_root()
	
func _process(_delta: float) -> void:
		pass
		
	

	

	

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
	if raycast.is_colliding() and raycast.get_collider().is_in_group("Shotgun"): #Raycast detwection on an Area3D to determine when the player can pick up.
			shotgun.visible = true
			equipped = true
			shotgun.emit_signal("pick_up")
			shotgun_ui.visible = true
			
			raycast.get_collider().get_parent().queue_free() #Deletes the object when picked up.
			
			
			
			
func drop_weapons() -> void:
	if equipped and shotgun.visible: # If visible and player wants to drop, instance a new object at a fixed area.
		shotgun.visible = false
		shotgun_ui.visible = false
		equipped = false
		var drop_pos = $"../../../WeaponDropPos"
		var weapon_position = drop_pos.global_transform.origin
		
		var instance_weapon = shotgun_preload.instantiate()
		instance_place.add_child(instance_weapon)
		
		instance_weapon.global_transform.origin = weapon_position
		instance_weapon.global_transform.basis = drop_pos.basis
		instance_weapon.rotation = Global.player.rotation + shotgun_position
		
		instance_weapon.apply_central_impulse(-Global.player.transform.basis.z * gun_impulse)


	
	
