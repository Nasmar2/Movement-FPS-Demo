class_name JumpingState

extends GlobalStateClass



func enter():
	ANIMATION_PLAYER.pause()
	PLAYER.velocity.y += PLAYER.jump_velocity
	


func _update(_delta):
	pass

func _physics_update(_delta):
	if !PLAYER.is_on_floor() and PLAYER.velocity.y < 0:
		transition.emit("FallingState")  # Transition to falling if moving upward and off the ground
	elif PLAYER.velocity.length() < 0.25 and PLAYER.is_on_floor():
		transition.emit("IdleState")  # Transition to idle if stationary on the ground
	elif PLAYER.velocity.length() > 0.25 and PLAYER.is_on_floor() and PLAYER.velocity.y == 0:
		transition.emit("RunningState")
	elif PLAYER.sliding:
		transition.emit("SlidingState")
		

func jump():
	pass
