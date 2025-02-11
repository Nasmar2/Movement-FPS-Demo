class_name GlobalStateClass

extends state

var PLAYER : Player
var ANIMATION_PLAYER
var coyote_state



func _ready() -> void:
	PLAYER = owner as Player
	ANIMATION_PLAYER = PLAYER.animation_player
	coyote_state = PLAYER.coyote_state
	
	
