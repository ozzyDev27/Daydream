extends CharacterBody2D
@onready var sprite = $Sprite

@export var moveSpeed = 250
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0
@export var bulletSpeed = 400

@export var movement_deadzone: float = 0.15
var bullet = load("res://Scenes/bullet.tscn")
var last_input_vector = Vector2.ZERO

func _ready():
	pass

func _physics_process(delta):
	var suffix = str(deviceID)
	var action_left = "dirLeft" + suffix
	var action_right = "dirRight" + suffix
	var action_up = "dirUp" + suffix
	var action_down = "dirDown" + suffix
	
	var input_vector = Input.get_vector(
		action_left, 
		action_right, 
		action_up, 
		action_down, 
		deviceID
	)
	
	last_input_vector = input_vector
	
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
		
	
	if Input.is_action_just_pressed("Action"+suffix):
		summonBullet()

	move_and_slide()

func summonBullet():
	var newBullet = bullet.instantiate()
	newBullet.position = position
	newBullet.direction = last_input_vector
	if last_input_vector.x<0.1 and last_input_vector.y<0.1:
		newBullet.direction.x = -1 if sprite.flip_h else 1
		newBullet.direction.y = 0
	newBullet.modifier = bulletSpeed
	get_parent().add_child(newBullet)
