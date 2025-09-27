extends CharacterBody2D
@onready var sprite = $Sprite
@onready var levelCam=$"../Camera"

@export var moveSpeed = 250
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0

@export var movement_deadzone: float = 0.15

func _ready():
	pass

func _physics_process(delta):
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
	
	if input_vector.length() > movement_deadzone:
		velocity = velocity.move_toward(input_vector * moveSpeed, acceleration * delta)
		
		sprite.play("Running")
		if velocity.x < 0:
			sprite.flip_h=true
		elif velocity.x > 0:
			sprite.flip_h=false
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		sprite.play("Standing")
		
	move_and_slide()
	
	print(input_vector.x," & ",input_vector.y)
