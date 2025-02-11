class_name FallingState

extends GlobalStateClass

func enter():
	ANIMATION_PLAYER.pause()


func _update(_delta):
	if PLAYER.velocity.length() and PLAYER.is_on_floor() and PLAYER.velocity.y == 0:
		transition.emit("RunningState")
	elif PLAYER.velocity.length() < 0.25 and PLAYER.is_on_floor():
		transition.emit("IdleState")
	elif Global.player.can_jump:
		transition.emit("JumpingState")
	elif PLAYER.sliding:
		transition.emit("SlidingState")
	
func _physics_update(_delta):
	pass
	
