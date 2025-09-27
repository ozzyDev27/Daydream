extends Area2D

var grabber: Node2D = null
@export var snap = Vector2(5, 5)
var original_position = null

func _ready():
	original_position = global_position

func _process(delta):
	if grabber:
		global_position = grabber.global_position.snapped(snap)
		if get_overlapping_areas():
			modulate = Color(Color.WHITE, 0.2)
		else:
			modulate = Color.WHITE
