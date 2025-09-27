extends Area2D

var grabber: Node2D = null
@export var snap = Vector2(5, 5)
var valid = true
var original_position = null

@export var upgrade_name = "slopgrade 1"

func _ready():
	original_position = global_position
	$Label.text = upgrade_name

func _process(delta):
	$Label.visible = not not grabber
	if grabber:
		global_position = grabber.global_position.snapped(snap)
		if get_overlapping_areas():
			valid = false
	if valid:
		modulate = Color.WHITE
	else:
		modulate = Color(Color.WHITE, 0.2)
