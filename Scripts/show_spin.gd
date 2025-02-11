extends Node

var parent
var spin_amount : float = 0.2

func _ready() -> void:
	parent = get_parent()
	
	
func _process(delta: float) -> void:
	parent.rotation_degrees += Vector3(0.0, spin_amount, 0.0)


	
