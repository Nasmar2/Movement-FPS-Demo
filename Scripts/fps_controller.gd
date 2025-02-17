class_name Player

extends CharacterBody3D

@export var top_air_speed : float = 50.0
@export var max_air_speed : float = 20.0
@export var speed = 5
@export var slide_speed : float = 1.25
@export var jump_velocity = 4.5
@export var max_coyote_time : float = 0.15
@export var wall_jump_velocity : float = 4.5
@export var acceleration : float = 0.1
@export var decceleration : float = 0.25
@export var mouse_sensitivity : float = 0.05
@export var air_control : float = 0.2
@export var slide_decel : float = 0.05
@export var max_air_slide_speed : float = 30
@export var hop_distance : float = 5.0
@export var camera_controller : Camera3D
@export var collision_shape : CollisionShape3D
@export var animation_player : AnimationPlayer
@export var AirTimer : Timer
@onready var ledge_raycast = $LedgeRaycast
@export var shotgun : RigidBody3D

var mouse_input : bool = false
var rotation_input : float
var mouse_rotation : Vector3
var tilt_input : float
var camera_rotation : Vector3
var player_rotation : Vector3
var character_sliding : bool = false
var input_disabled : bool = false
var direction: Vector3 = Vector3.ZERO
var camera_limit_up := deg_to_rad(90)
var camera_limit_down := deg_to_rad(-90)
var sliding : bool = false
var sliding_velocity
var pushing_p = Vector3.ZERO
var air_velo = Vector3.ZERO
var floor_normal
var slope_dir
var coyote_state : bool = false
var wall_normal
var can_ledge : bool = true
var horizontal_velo = Vector3.ZERO
var coyote_timer : float = 0
var can_jump
var external_knockback = Vector3.ZERO

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	Global.player = self

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()
		
	if Input.is_action_just_pressed("M_Jump"):
		coyote_timer = max_coyote_time

		
func _unhandled_input(event: InputEvent) -> void:
	#Check if there is mouse input and it is at the correct mode.
	mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED
	
	#If it is at the correct mode get the relative positions of the x and y of the mouse.
	if mouse_input:
		rotation_input = -event.relative.x * mouse_sensitivity
		tilt_input = -event.relative.y * mouse_sensitivity
		
		#Set the x mouse rotation to the tilt input * delta and clamp it to not go above or below 90 degrees. And then set the y mouse rotation.
		mouse_rotation.x += tilt_input * mouse_sensitivity
		mouse_rotation.x = clamp(mouse_rotation.x, camera_limit_down, camera_limit_up)
		mouse_rotation.y += rotation_input * mouse_sensitivity
		
func update_camera(_delta):
	#Here we set camera camera rotation and player rotation in order to move them seperately.
	player_rotation = Vector3(0.0, mouse_rotation.y, 0.0)
	camera_rotation = Vector3(mouse_rotation.x,0.0 , 0.0)
	
	#Move the camera based on euler rotation of the x and y and reset the z to 0 so it doesn't affect the camera movement.
	camera_controller.transform.basis = Basis.from_euler(camera_rotation)
	camera_controller.rotation.z = 0.0
	
	#Here we rotate the player on the x axis according to the mouse relative rotation.
	global_transform.basis = Basis.from_euler(player_rotation)
	
	#Reset again the rotation input and tilt input everytime so the camera stops.
	rotation_input = 0.0
	tilt_input = 0.0

func _process(_delta: float) -> void:
	var fps = Engine.get_frames_per_second()
	
	#Add the fps counter in the debug panel.
	Global.debug.add_property("FPS", fps, 1)
	Global.debug.add_property("MOUSE ROTATION", mouse_rotation, 2)
	Global.debug.add_property("VELOCITY", velocity, 3)
	Global.debug.add_property("ANIMATION", $PlayerBobbing.current_animation, 4)
	Global.debug.add_property("ANIM_SPEED", $PlayerBobbing.speed_scale, 5)
	Global.debug.add_property("CH_HEIGHT", $CollisionShape3D.shape.height, 6)
	Global.debug.add_property("DECEL", decceleration, 7)
	Global.debug.add_property("IS_ON_FLOOR", is_on_floor(), 8)
	Global.debug.add_property("REAL VELOCITY", get_real_velocity(), 9)
	Global.debug.add_property("MAX_AIR_SPEED", max_air_speed, 13)
	
func slide(_delta) -> void:
	floor_normal = get_floor_normal()
	slope_dir = (floor_normal.cross(Vector3.UP).cross(floor_normal).normalized())
	var slope_velocity = Vector3.ZERO
	var slope_factor = -slope_dir.y
	
	sliding_velocity = Vector3(velocity.x, 0, velocity.z)
	
	if Input.is_action_just_pressed("M_Slide"):
		$CrouchAnimation.play("Crouch")
		sliding = true

		pushing_p = Vector3(velocity.x, 0, velocity.z) #Stores last velocity player outputted to a variable for use in sliding mechanic.
		
		#Sets speed and air speed to their maximum values while sliding is active.
		if is_on_floor() and velocity.length() != 0.0:
			speed = 10.0
			max_air_speed = max_air_slide_speed

	elif Input.is_action_just_released("M_Slide"):
		$CrouchAnimation.play("Uncrouch")
		sliding = false
		AirTimer.start()
	
	Global.debug.add_property("AIRTIMER", AirTimer.time_left, 21)
	
	if is_on_floor() and !sliding:
		if AirTimer.time_left == 0.0:
			max_air_speed = 10.0
			speed = 10.0

	# Sliding decel function.
	if is_on_floor():
		if slope_dir != Vector3.ZERO:
			
			if slope_factor < 0.0 and sliding:
				slide_decel = 0.0
				var slope_acceleration = slope_factor * slide_speed
				slope_velocity = slope_dir * slope_acceleration
				velocity += slope_velocity
		elif slope_dir == Vector3.ZERO and sliding:
			slide_decel = 0.01
		
			sliding_velocity.x = lerp(sliding_velocity.x, 0.0, 1.0 -exp(-slide_decel))
			sliding_velocity.z = lerp(sliding_velocity.z, 0.0, 1.0 -exp(-slide_decel))
			
			velocity.x = sliding_velocity.x
			velocity.z = sliding_velocity.z
		
	Global.debug.add_property("SLOPE_FACTOR", slope_factor, 16)
	Global.debug.add_property("SLIDE_DECEL", slide_decel, 11)
	Global.debug.add_property("SLOPE_NORMAL", floor_normal, 11)
	Global.debug.add_property("SLOPE_DIR", slope_dir, 10)
	Global.debug.add_property("PUSHIN_P", pushing_p, 17)
	Global.debug.add_property("AIR VELO", air_velo, 16)
		
	max_air_speed = clamp(max_air_speed, 0.0, top_air_speed)
	
func _physics_process(delta: float) -> void:
	update_camera(delta)
	slide(delta)
	coyote_time(delta)
	check_collisions()

	
	# Add the gravity.
	velocity += get_gravity() * delta
	
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("M_Left", "M_Right", "M_Forward", "M_Backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction and is_on_floor() and !sliding:
		velocity.x = lerp(velocity.x, direction.x * speed, acceleration)
		velocity.z = lerp(velocity.z, direction.z * speed, acceleration)
	elif is_on_floor() and !sliding:
		velocity.x = lerp(velocity.x, 0.0, 1.0 -exp(-decceleration))
		velocity.z = lerp(velocity.z, 0.0, 1.0 -exp(-decceleration))

	if direction and !sliding and !is_on_floor():
		air_velo = Vector3(velocity.x, velocity.y, velocity.z)
		
		air_velo += direction * air_control #Apply new velocity on top of the existing one to give the user limited control in the air
			
		
		
	
		horizontal_velo = Vector2(air_velo.x, air_velo.z)  # Only consider X and Z for horizontal speed
		
		if horizontal_velo.length() > max_air_speed: # Limit Air Speed
			horizontal_velo = horizontal_velo.normalized() * max_air_speed

		#Reapply the modified horizontal velocity back to air_velo
		air_velo.x = horizontal_velo.x
		air_velo.z = horizontal_velo.y
			
		#Finally, apply the updated air velocity to the main velocity
		velocity.x = air_velo.x
		velocity.z = air_velo.z
		
	Global.debug.add_property("knockback", external_knockback, 20)

	#Wall Jumping, Wall Running.
	if is_on_wall() and !is_on_floor() and !sliding:
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 12.0)
		max_air_speed = 30
		
		
		wall_normal = get_wall_normal()

		velocity += -wall_normal
		
		if Input.is_action_just_pressed("M_Jump"):
			velocity += wall_normal * 10
			velocity.y = wall_jump_velocity
			
		if can_ledge and ledge_raycast.is_colliding() and !sliding:
			var tween := get_tree().create_tween()
				
			tween.tween_property(self, "velocity", Vector3(0, hop_distance, 0), 0.1).set_ease(Tween.EASE_IN)
	else:
		PhysicsServer3D.area_set_param(get_viewport().find_world_3d().space, PhysicsServer3D.AREA_PARAM_GRAVITY, 24.0)
		
	Global.debug.add_property("wall_normal", wall_normal, 17)
	Global.debug.add_property("is_on_wall", is_on_wall(), 18)
	Global.debug.add_property("can_ledge", can_ledge, 19)
	move_and_slide()

func coyote_time(delta) -> void:
	if coyote_timer > 0.0:
		coyote_timer -= delta
	
	coyote_timer = max(coyote_timer - delta, 0.0)
	
	if is_on_floor():
		if coyote_timer > 0.0:
			can_jump = true
			coyote_timer = 0.0
	else:
		can_jump = false
			
	Global.debug.add_property("coyote_timer", coyote_timer, 20)

func check_collisions() -> void:
	if $LedgeDetection.get_overlapping_bodies().size() > 0:
		can_ledge = false
	else:
		can_ledge = true
