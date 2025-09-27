extends Node2D

var speed = 1
var health = 3
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
	body.damage_flash()
	queue_free() # TODO VFX

func damage_flash():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(10, 10, 10), 0.03)
	tween.tween_property(self, "modulate", Color.WHITE, 0.03)
	#tween.tween_callback(tween.queue_free)

func damage(amount: int):
	health -= amount
	damage_flash()
	if health <= 0:
		queue_free() # TODO death FX
