extends Node3D

var player = Player
@onready var raycast_left = $"../TweenerRaycasts/Left"
@onready var raycast_right = $"../TweenerRaycasts/Right"
@onready var camera = $Camera3D

func _process(_delta: float) -> void:
	player = owner as Player
	start_tween()

func start_tween():
	if player.is_on_wall() and !player.is_on_floor() and !player.sliding:
		if raycast_left.is_colliding():
			camera_left()
		elif raycast_right.is_colliding():
			camera_right()
	else:
		camera_reset()
	
func camera_left():
	var tween := get_tree().create_tween()
	
	tween.tween_property(self, "rotation", Vector3(0, 0, -0.25), 0.25).set_ease(Tween.EASE_IN)
		
func camera_right():
	var tween := get_tree().create_tween()
	
	tween.tween_property(self, "rotation", Vector3(0, 0, 0.25), 0.25).set_ease(Tween.EASE_IN)
	
func camera_reset():
	var tween := get_tree().create_tween()
	
	tween.tween_property(self, "rotation", Vector3(0, 0, 0), 0.25).set_ease(Tween.EASE_IN)
