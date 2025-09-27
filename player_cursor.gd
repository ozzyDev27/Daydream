extends Sprite2D

@export var deviceID = 0
@export var speed = 10

func _process(delta):
	var suffix = str(deviceID)
	var action_left  = "dirLeft" + suffix
	var action_right = "dirRight" + suffix
	var action_up    = "dirUp" + suffix
	var action_down  = "dirDown" + suffix
	
	var input_vector = Input.get_vector(
		action_left, 
		action_right, 
		action_up, 
		action_down, 
		deviceID
	)
	
	global_position += input_vector * speed
	
	if Input.is_action_just_pressed("Action0") and $Area2D.get_overlapping_areas():
		$Area2D.get_overlapping_areas()[0].get_parent().grabber = self
	if Input.is_action_just_released("Action0") and $Area2D.get_overlapping_areas():
		$Area2D.get_overlapping_areas()[0].get_parent().grabber = null
	
