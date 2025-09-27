extends Area2D

var grabber: Node2D = null
var snap = Vector2(32, 32)
@export var highlight_color: Color
var valid = true
var original_position = null

@export var upgrade_name = "slopgrade 1"

func _ready():
	original_position = global_position
	$Base/Highlight.self_modulate = highlight_color
	

func _process(delta):
	if grabber:
		global_position = grabber.global_position.snapped(snap)
		if get_overlapping_areas():
			valid = false
		if valid:
			modulate = Color(Color.WHITE, 0.8)
		else:
			modulate = Color(Color.WHITE, 0.2)
	else:
		modulate = Color.WHITE
