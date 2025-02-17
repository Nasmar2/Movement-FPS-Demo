extends Node

var parent
var spin_amount : float = 180.0

func _ready() -> void:
	parent = get_parent()
	
	parent.axis_lock_linear_y = true
	
func _process(delta: float) -> void:
	parent.rotation_degrees += Vector3(0.0, spin_amount * delta, 0.0)
	
	
	
