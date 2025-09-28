extends Node2D

func _input(event):
	if event.is_action_pressed("Jump"):
		print("amooooogus")
		startgame()

func startgame() -> void:
	get_tree().change_scene_to_file("res://Scenes/Levels/intro_cutscene.tscn")
	
