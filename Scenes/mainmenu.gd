extends Node2D


func startgame() -> void:
	var scene = load("res://Scenes/Levels/level_1.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.get_node("Camera").make_current()
	scene.get_node("Player0").level=1
	self.queue_free()
	
