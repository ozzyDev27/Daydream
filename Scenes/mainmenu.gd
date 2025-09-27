extends Node2D


func startgame() -> void:
	var scene = load("res://Scenes/tilemap_test.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.get_node("Camera").make_current()
	self.queue_free()
	
