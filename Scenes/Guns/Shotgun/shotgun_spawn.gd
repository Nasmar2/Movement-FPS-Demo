extends RigidBody3D

var shader_despawn : float = 20.0
var weapon_handler
@onready var shader_applier = $ShaderApplier

func _process(delta: float) -> void:
	if global_position.distance_to(Global.player.global_position) < shader_despawn and !weapon_handler:
		shader_applier._apply_shader_material()
	else:
		shader_applier.erase_mesh_to_children()
