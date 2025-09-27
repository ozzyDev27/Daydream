extends CharacterBody2D
@onready var sprite = $Sprite
@onready var levelCam=$"../Camera"

# Character Stats
@export var moveSpeed = 250
@export var acceleration = 2000
@export var friction = 1000 
@export var playerNum=0

func _ready():
	pass

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_axis("dirLeft", "dirRight")
	input_vector.y = Input.get_axis("dirUp", "dirDown")
	input_vector = input_vector.normalized()
	
	var target_velocity = input_vector * moveSpeed
	
	if input_vector.length() > 0:
		velocity = velocity.move_toward(target_velocity, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	move_and_slide()
	
	# ANIMATIONS
	if velocity.length() < 10: 
		sprite.play("Standing")
	else:
		sprite.play("Running")
		if velocity.x<0:
			sprite.flip_h=true
		if velocity.x>0:  #if 0, it doesnt change
			sprite.flip_h=false
