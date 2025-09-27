extends Node2D

var speed = 1
var nearest_player: Node2D = null

func get_nearest_player():
	var nearest_distance = 100000
	for player in get_tree().get_nodes_in_group("players"):
		var distance = global_position.distance_to(player.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_player = player

func _physics_process(delta):
	if nearest_player:
		var target_dir = global_position.direction_to(nearest_player.global_position)
		position += target_dir * speed
	get_nearest_player()

# hit by player
func _on_area_2d_body_entered(body):
	#body.health -= 1
	queue_free() # TODO VFX
