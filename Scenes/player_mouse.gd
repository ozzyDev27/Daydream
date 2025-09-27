extends CharacterBody2D
@onready var sprite = $Sprite
 ## THIS IS THE MOUSE SCRIPT!!!!!!!!!!!!!!!!!!!!!!
@export var moveSpeed = 150
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0

@export var movement_deadzone: float = 0.15

signal startGame
var touchingStart = false

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
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		
	move_and_slide()
	if touchingStart and (Input.is_action_just_pressed("Jump"+suffix) or Input.is_action_just_pressed("Action"+suffix)):
		emit_signal("startGame")


func _on_start_body_entered(_body: Node2D) -> void:
	touchingStart=true
	sprite.play("light")

func _on_start_body_exited(_body: Node2D) -> void:
	touchingStart=false
	sprite.play("dark")
