extends CenterContainer

@export var player_controller: CharacterBody3D
@export var raycast: RayCast3D
@export var dot_radius: float = 1.0
@export var dot_color: Color = Color.WHITE
@export var highlight_radius: float = 3.0
@export var normal_radius: float = 1.0

var temp_radius: float

func _ready() -> void:
	temp_radius = dot_radius


func _process(_delta: float) -> void:
	check_reticle()

	# Smooth transition for dot size change
	temp_radius = lerp(temp_radius, dot_radius, 0.2)
	if abs(temp_radius - dot_radius) > 0.01:
		queue_redraw()


func _draw() -> void:
	draw_circle(Vector2(0, 0), temp_radius, dot_color)


func check_reticle() -> void:
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider and collider.is_in_group("Reticle_Enable"):
			dot_radius = highlight_radius
			return

	# Default state if not colliding with valid target
	dot_radius = normal_radius
