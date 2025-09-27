extends Node2D

@export var enemy: PackedScene = null
@export var spawn_delay = 1
@export var spawn_radius = 50
@export var spawn_count = 10

func _ready():
	GlobalState.spawners_remaining += 1
	start_spawning()

func start_spawning():
	$Timer.wait_time = spawn_delay
	$Glow.visible = true
	$Timer.start()
	
func spawn():
	spawn_count -= 1
	if spawn_count <= 0:
		$Glow.visible = false
		GlobalState.spawners_remaining -= 1
		$Timer.stop()
	var new_enemy = enemy.instantiate()
	new_enemy.global_position = global_position + Vector2(spawn_radius * (randf() - 0.5), spawn_radius * (randf() - 0.5))
	get_parent().add_child(new_enemy)
