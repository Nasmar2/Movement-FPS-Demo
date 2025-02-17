extends Node

var original_rotation : Vector3
var mouse_motion : float
var mouse_rot : Vector3
var rot_input : float = 0.0
var tilt_input : float = 0.0
var tilt_motion : float
var parent
var sway_x = Vector3.ZERO

@export var minimum_motion_threshold : float = 0.2
@export var input_strength : float = 7.5
@export var max_y : float = 40.0
@export var max_z : float = 30.0
@export var sway_weight : float = 15.0
@export var sway_return : float = 5.0

func _ready() -> void:
	parent = get_parent()
	
	original_rotation = parent.rotation_degrees
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and parent.visible:
		rot_input = -event.relative.x * Global.player.mouse_sensitivity * input_strength
		tilt_input = (-event.relative.y * Global.player.mouse_sensitivity) * input_strength
		
		mouse_rot.z += tilt_input * Global.player.mouse_sensitivity
		mouse_rot.y += rot_input * Global.player.mouse_sensitivity
		
func _process(_delta: float) -> void:
	if parent.visible:
		mouse_motion = Global.player.rotation_input * 5.0
		tilt_motion = Global.player.tilt_input * 5.0 
		
func _physics_process(delta: float) -> void:
		shotgun_sway(delta)

func shotgun_sway(delta) -> void:
	if abs(mouse_motion) > minimum_motion_threshold or abs(tilt_motion) > minimum_motion_threshold:
		sway_x = sway_x.lerp(mouse_rot, sway_weight * delta)
	else:
		sway_x = sway_x.lerp(Vector3.ZERO, sway_return * delta)
		
		mouse_rot.y = 0.0
		mouse_rot.z = 0.0
	
	sway_x.y = clamp(sway_x.y, -max_y, max_y)
	sway_x.z = clamp(sway_x.z, -max_z, max_z)

	parent.rotation_degrees = sway_x + original_rotation
