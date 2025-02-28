extends Node3D

@export var player_camera: Camera3D
@export var max_shake: float = 10.0
@export var max_trauma : float = 5.0
var current_trauma: float = 0.0
var trauma_decay: float = 1.0

func _ready() -> void:
	Global.camera_trauma = self
	# current_trauma starts at 0; you can add trauma from elsewhere

# This function can be called from any script
func add_trauma(amount: float, decay : float, shake : float) -> void:
	# Increase trauma by the specified amount, clamped to a maximum (e.g., 1.0)
	current_trauma = amount
	trauma_decay = decay
	max_shake = shake
	
func _process(delta: float) -> void:
	# Decay the trauma over time, ensuring it never goes below zero
	current_trauma = max(current_trauma - trauma_decay * delta, 0.0)
	current_trauma = clamp(current_trauma, -max_trauma, max_trauma)
	# Apply the camera shake based on the current trauma value
	var x_rot = current_trauma * randf_range(-max_shake, max_shake)
	var y_rot = current_trauma * randf_range(-max_shake, max_shake)
	var z_rot = current_trauma * randf_range(-max_shake, max_shake)

	
	player_camera.rotation_degrees += lerp(Vector3.ZERO, Vector3(x_rot, y_rot, z_rot), 0.01)

	Global.debug.add_property("current_trauma", current_trauma, 23)
