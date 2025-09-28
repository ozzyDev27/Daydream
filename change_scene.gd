extends Area2D

var player_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta) -> void:
	if len(get_overlapping_bodies()) == 1:
		get_tree().change_scene_to_file("res://Scenes/Levels/upgrades_1.tscn")
