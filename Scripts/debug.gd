extends PanelContainer

@onready var property_container = %VBoxContainer
var property
var fps

func _ready() -> void:
	#Set the reference of the global debug panel.
	Global.debug = self
	visible = false
	


func _physics_process(_delta: float) -> void:
	pass
		
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DebugPanel"):
		visible = !visible
		

func add_property(title : String, value, order):
	var target
	target = property_container.find_child(title, true, false)
	if !target:
		target = Label.new()
		property_container.add_child(target)
		target.name = title
		target.text = target.name + ": " + str(value)
	elif visible:
		target.text = title + ": " + str(value)
		property_container.move_child(target, order)
