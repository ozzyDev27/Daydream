extends Node2D

var active = false

func on_player_enter(_body: Node2D):
	print("Enemies remaining:", len(get_tree().get_nodes_in_group("enemy")))
	print("Spawners remaining:", GlobalState.spawners_remaining)
	print("Bodies:", len($Area2D.get_overlapping_bodies()))
	if len(get_tree().get_nodes_in_group("enemy")) == 0 and GlobalState.spawners_remaining == 0:
		$AnimatedSprite2D.show()
	if len(get_tree().get_nodes_in_group("enemy")) == 0 and GlobalState.spawners_remaining == 0 and len($Area2D.get_overlapping_bodies()) == 1:
		# next level
		$AnimatedSprite2D.hide()
		GlobalState.level += 1
		print("Go to next level...")
		get_tree().change_scene_to_file("res://Scenes/Levels/upgrades_%d.tscn" % GlobalState.level)
