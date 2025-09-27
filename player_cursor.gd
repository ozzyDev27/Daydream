extends Sprite2D

@export var deviceID = 0
@export var speed = 10

func _process(delta):
	if Input.is_action_just_pressed("Action0") and $Area2D.get_overlapping_areas():
		$Area2D.get_overlapping_areas()[0].grabber = self
		$Area2D.get_overlapping_areas()[0].valid = false
	if Input.is_action_just_released("Action0") and $Area2D.get_overlapping_areas():
		var grab_target = $Area2D.get_overlapping_areas()[0]
		if not grab_target.valid:
			grab_target.global_position = grab_target.original_position
			grab_target.valid = true
		$Area2D.get_overlapping_areas()[0].grabber = null
	
