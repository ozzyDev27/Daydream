extends CharacterBody2D
@onready var sprite = $Sprite
 ## THIS IS THE MOUSE SCRIPT!!!!!!!!!!!!!!!!!!!!!!
@export var moveSpeed = 150
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0
var level=0

@export var movement_deadzone: float = 0.15

signal startGame
var touchingStart = false
var touching_next_level = false

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
	if Input.is_action_just_pressed("Jump") and deviceID==0:
		nextLevel()
		
	if input_vector.length() > movement_deadzone:
		velocity = velocity.move_toward(input_vector * moveSpeed, acceleration * delta)
		
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
		
	move_and_slide()
	if touchingStart and (Input.is_action_just_pressed("Jump"+suffix) or Input.is_action_just_pressed("Action"+suffix)):
		emit_signal("startGame")
	
	if touching_next_level and (Input.is_action_just_pressed("Jump"+suffix) or Input.is_action_just_pressed("Action"+suffix)):
		get_tree().change_scene_to_file("res://Scenes/Levels/level_%d.tscn" % GlobalState.level)
	
	if touchingStart or touching_next_level:
		sprite.play("light")
	else:
		sprite.play("dark")


func _on_start_body_entered(_body: Node2D) -> void:
	touchingStart=true

func _on_start_body_exited(_body: Node2D) -> void:
	touchingStart=false

func nextLevel() -> void:
	var scene = load(str("res://Scenes/enemy_test.tscn")).instantiate()
	get_tree().root.add_child(scene)
	scene.get_node("Camera").make_current()
	scene.get_node("Player0").level=level
	get_parent().queue_free()
