extends Sprite2D

@onready var deviceID = get_parent().deviceID
var currently_holding: Node2D = null
@export var speed = 10

func _process(delta):
	if Input.is_action_just_pressed("Action" + str(deviceID)) and $Area2D.get_overlapping_areas():
		$Area2D.get_overlapping_areas()[0].grabber = self
		$Area2D.get_overlapping_areas()[0].valid = false
		currently_holding = $Area2D.get_overlapping_areas()[0]
	if Input.is_action_just_released("Action" + str(deviceID)) and currently_holding:
		if not currently_holding.valid:
			currently_holding.global_position = currently_holding.original_position
			currently_holding.valid = true
		currently_holding.grabber = null
		currently_holding = null
		
	
	if not get_node("../../Player%dHover" % (deviceID+1)):
		print("Error! failed to find hovers")
		return
	if $Area2D.get_overlapping_areas() and "upgrade_name" in $Area2D.get_overlapping_areas()[0]:
		get_node("../../Player%dHover" % (deviceID+1)).text = $Area2D.get_overlapping_areas()[0].upgrade_name
	else:
		get_node("../../Player%dHover" % (deviceID+1)).text = ""
