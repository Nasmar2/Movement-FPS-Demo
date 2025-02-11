extends Node

var original_rotation : Vector3
var mouse_motion : float
var mouse_rot : Vector3
var rot_input : float = 0.0
var tilt_input : float = 0.0
var tilt_motion : float
var parent
var minimum_motion_threshold : float = 0.2

func _ready() -> void:
	parent = get_parent()
	
	original_rotation = parent.rotation_degrees
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and parent.visible:
		rot_input = -event.relative.x * Global.player.mouse_sensitivity
		tilt_input = (-event.relative.y * Global.player.mouse_sensitivity) * 2.5
		
		mouse_rot.z += tilt_input * Global.player.mouse_sensitivity
		mouse_rot.y += rot_input * Global.player.mouse_sensitivity
		
func _process(delta: float) -> void:
	if parent.visible:
		mouse_motion = Global.player.rotation_input * 5.0
		tilt_motion = Global.player.tilt_input * 5.0
		
		shotgun_sway()
		
		
	
func shotgun_sway() -> void:
	var sway_weight : float = 15.0
	var sway_x = Vector3.ZERO
	
	if abs(mouse_motion) > minimum_motion_threshold or abs(tilt_motion) > minimum_motion_threshold:
		sway_x = sway_x.lerp(mouse_rot, sway_weight)
		parent.rotation_degrees = sway_x + original_rotation
	elif abs(mouse_motion) < minimum_motion_threshold or abs(tilt_motion) < minimum_motion_threshold:
		sway_x = sway_x.lerp(Vector3.ZERO, sway_weight)
		parent.rotation_degrees = sway_x + original_rotation
		mouse_rot.y = 0.0
		mouse_rot.z = 0.0
	
	
