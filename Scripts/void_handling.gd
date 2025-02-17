extends Node3D

@export var checkpoints: Array[NodePath] # Array of checkpoint node paths
var visited_checkpoints := {} # Dictionary to track visited checkpoints

func _process(_delta: float):
	# Check if the player is below the VoidHandler
	if Global.player.global_position.y < self.global_position.y:
		teleport_to_closest_checkpoint()
	
	# Continuously check if the player is close to any checkpoint
	for checkpoint_path in checkpoints:
		var checkpoint = get_node(checkpoint_path)
		if checkpoint:
			# Use the checkpoint's path as the dictionary key
			var checkpoint_key = str(checkpoint_path)
			if not visited_checkpoints.get(checkpoint_key, false): # Check if visited
				if Global.player.global_position.distance_to(checkpoint.global_position) <= 5.0: # Unlock radius
					visited_checkpoints[checkpoint_key] = true # Mark as visited

func teleport_to_closest_checkpoint():
	var closest_checkpoint: Node3D = null
	var closest_distance := INF # Initialize with a very large number

	# Iterate through all checkpoints
	for checkpoint_path in checkpoints:
		var checkpoint = get_node(checkpoint_path)
		if checkpoint:
			# Use the checkpoint's path as the dictionary key
			var checkpoint_key = str(checkpoint_path)
			if visited_checkpoints.get(checkpoint_key, false): # Only consider visited checkpoints
				# Calculate the distance between the player and the checkpoint
				var distance = Global.player.global_position.distance_to(checkpoint.global_position)
				if distance < closest_distance:
					closest_distance = distance
					closest_checkpoint = checkpoint

	# Teleport the player to the closest visited checkpoint
	if closest_checkpoint:
		Global.player.global_position = closest_checkpoint.global_position
