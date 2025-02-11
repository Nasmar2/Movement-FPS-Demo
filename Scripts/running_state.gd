class_name RunningState

extends GlobalStateClass


@export var max_anim_speed : float = 3.2

func enter() -> void:
	ANIMATION_PLAYER.play("Running", -1.0, 1.0)

	
	
func _update(_delta):
	set_anim_speed(Global.player.velocity.length())
	

func set_anim_speed(p_speed):
	var alpha = remap(p_speed,0.0, Global.player.speed, 0.0, 1.0)
	ANIMATION_PLAYER.speed_scale = lerp(0.0, max_anim_speed, alpha)

func _physics_update(_delta):
	
	
	
		
	if PLAYER.velocity.length() < 0.25 and PLAYER.is_on_floor():
		transition.emit("IdleState")
	elif Global.player.can_jump:
		transition.emit("JumpingState")
	elif PLAYER.velocity.y <= 0 and !PLAYER.is_on_floor():
		transition.emit("FallingState")
	elif PLAYER.sliding:
		transition.emit("SlidingState")
	
