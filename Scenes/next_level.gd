extends Button



func _on_pressed():
	#TODO check if valid
	
	get_tree().change_scene_to_file("res://Scenes/levels/level_%d.tscn" % GlobalState.level)
