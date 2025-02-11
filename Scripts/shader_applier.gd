extends Node3D

var shader_material = ShaderMaterial.new()
var parent_node

func _ready() -> void:
	parent_node = get_parent()

func _apply_shader_material() -> void:
		shader_material.shader = load("res://Shaders/outline.gdshader")
		shader_material.set_shader_parameter("outline_color", Color(1,1,1,1))

		_apply_mesh_to_children(parent_node, shader_material)
	
func _apply_mesh_to_children(root_node : Node, material: ShaderMaterial) -> void:
	for children in root_node.get_children():
		if children is MeshInstance3D:
			children.material_overlay = material
		_apply_mesh_to_children(children, material)
		
func erase_mesh_to_children() -> void:
	_apply_mesh_to_children(parent_node, null)
