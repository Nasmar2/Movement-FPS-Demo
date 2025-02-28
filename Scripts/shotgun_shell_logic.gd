extends Control

@onready var shells = $"."
var shell_children
func _ready() -> void:
	#shells = get_children()
	shell_children = get_children()
	

func remove_shells(_count : int) -> void:
	if is_instance_valid(shells):
		if shells.get_child(0).visible:
				shells.get_child(0).visible = false
		else:
			shells.get_child(1).visible = false
	

func add_shells(_count : int) -> void:
	for i in shell_children:
		i.visible = true
	
