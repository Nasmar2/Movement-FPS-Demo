class_name StateMachine

extends Node

@export var CURRENT_STATE : state
var states : Dictionary = {}

func _ready() -> void:
	#We find all the states that are valid and put them into a dictionary for use.
	for child in get_children():
		if child is state:
			states[child.name] = child
			child.transition.connect(_on_child_transition)
		else:
			push_warning("Not found or not compatible child.")

	#Then we enter the current states custom function code.
	CURRENT_STATE.enter()
	
func _process(delta: float) -> void:
	#Update the current state every second.
	CURRENT_STATE._update(delta)
	
	#Debug menu statement.
	Global.debug.add_property("STATE", CURRENT_STATE.name, 4)
	
func _physics_process(delta: float) -> void:
	#Update the physics state of the current state.
	CURRENT_STATE._physics_update(delta)
	
func _on_child_transition(new_state_name : String) -> void:
	#It stores the new state name in the ready function that we trigger from the states in PlayerStateMachine that are then stored as a string in the dictionary.
	var new_state = states.get(new_state_name)
	if new_state != null:
		if new_state != CURRENT_STATE:
			CURRENT_STATE.exit() #Call the enter function in the states code.
			new_state.enter() #Call the exit function in the states code.
			CURRENT_STATE = new_state #Set the current state to the new state.
	else:
		push_warning("State isn't found or doesn't exist.")
