extends Sprite2D

var grabber: Node2D = null
@export var snap = Vector2(5, 5)

func _process(delta):
	if grabber:
		global_position = grabber.global_position.snapped(snap)
