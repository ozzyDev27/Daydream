extends Camera2D

@onready var playerOne = $"../Player0"
@onready var playerTwo = $"../Player1"

@export var min_zoom: float = 0.5 
@export var max_zoom: float = 3.0 
@export var max_distance: float = 500.0
@export var zoom_speed: float = 2.0 

func _physics_process(delta):
	position.x = ((playerOne.position.x + playerTwo.position.x) / 2)
	position.y = ((playerOne.position.y + playerTwo.position.y) / 2)
	
	var distance = playerOne.position.distance_to(playerTwo.position)
	var inverse_ratio = 1.0 - clamp(distance / max_distance, 0.0, 1.0)
	var target_zoom_factor = lerp(min_zoom, max_zoom, inverse_ratio)

	var target_zoom = Vector2(target_zoom_factor, target_zoom_factor)

	zoom = zoom.lerp(target_zoom, delta * zoom_speed)
