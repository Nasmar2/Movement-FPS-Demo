class_name GlobalStateClass

extends state

var PLAYER : Player
var ANIMATION_PLAYER
var coyote_state
var shotgun_sway_anim


func _ready() -> void:
	PLAYER = owner as Player
	ANIMATION_PLAYER = PLAYER.animation_player
	coyote_state = PLAYER.coyote_state
	shotgun_sway_anim = PLAYER.shotgun_sway_anim
	
