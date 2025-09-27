extends CharacterBody2D
@onready var sprite = $Sprite

@export var moveSpeed = 250
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0
@export var bulletSpeed = 400
@export var upgrades: Array[String] = []
@export var health = 10

var level=0
@export var movement_deadzone: float = 0.15
var bullet = load("res://Scenes/bullet.tscn")
var last_input_vector = Vector2.ZERO

func _ready():
	if deviceID == 0:
		upgrades = GlobalState.player0upgrades
	elif deviceID == 1:
		upgrades = GlobalState.player1upgrades
	elif deviceID == 2:
		upgrades = GlobalState.player2upgrades
	elif deviceID == 3:
		upgrades = GlobalState.player3upgrades
	print(upgrades)
	print(level)

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
	if input_vector.length() > 0:
		$SlashArea.rotation = input_vector.angle()
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
		
	if Input.is_action_just_pressed("DebugAction") and deviceID==0:
		nextLevel()
	if Input.is_action_just_pressed("Action"+suffix) and "Battery Bullet" in upgrades:
		summonBullet()
	if Input.is_action_just_pressed("Jump"+suffix) and "Slash Attack" in upgrades:
		slashAttack()

	move_and_slide()

func damage_flash():
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(10, 10, 10), 0.03)
	tween.tween_property(self, "modulate", Color.WHITE, 0.03)

func slashAttack():
	for body in $SlashArea.get_overlapping_areas():
		if body.is_in_group("damageable"):
			body.get_parent().damage(1)

func summonBullet():
	var newBullet = bullet.instantiate()
	newBullet.position = position
	newBullet.direction = last_input_vector
	if last_input_vector.x<0.1 and last_input_vector.y<0.1:
		newBullet.direction.x = -1 if sprite.flip_h else 1
		newBullet.direction.y = 0
	newBullet.modifier = bulletSpeed
	get_parent().add_child(newBullet)
func nextLevel() -> void:
	var scene = load("res://Scenes/upgrades.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.get_node("Camera").make_current()
	scene.get_node("PlayerMouse").level=level
	get_parent().queue_free()
