extends Node2D

func _input(event):
	if event.is_action_pressed("Jump0"):
		startgame()

func startgame() -> void:
	get_tree().change_scene_to_file("res://intro_cutscene.tscn")
	
