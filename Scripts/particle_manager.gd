extends Node3D

@onready var particles = $GPUParticles3D

func shooting_particles() -> void:
	particles.restart()
