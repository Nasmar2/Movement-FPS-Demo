extends Node3D

var shader_material = ShaderMaterial.new()
var parent_node

func _ready() -> void:
	parent_node = get_parent()
	
func viewmodel_shader() -> void:
	shader_material.shader = load("res://Shaders/viewmodel_shader.gdshader")
	
	_apply_viewmodel_shader(parent_node, shader_material)
	
	
func _apply_viewmodel_shader(node : Node, material : ShaderMaterial) -> void:
	for children in node.get_children():
		if children is MeshInstance3D:
			children.material_overlay = material
			
			
		
		_apply_viewmodel_shader(children, material)

func remove_viewmodel_shader() -> void:
	_apply_viewmodel_shader(parent_node, null)
