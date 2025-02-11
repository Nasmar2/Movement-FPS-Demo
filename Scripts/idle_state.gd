class_name IdleState

extends GlobalStateClass


func enter() -> void:
	PLAYER.velocity = Vector3.ZERO
	ANIMATION_PLAYER.pause()

func _update(_delta):
	if PLAYER.velocity.length() > 0.25 and PLAYER.is_on_floor():
		transition.emit("RunningState")
	elif Global.player.can_jump:
		transition.emit("JumpingState")
	elif PLAYER.velocity.y <= 0 and !PLAYER.is_on_floor():
		transition.emit("FallingState")
	elif PLAYER.sliding:
		transition.emit("SlidingState")
		
		
func _physics_update(_delta):
	pass
