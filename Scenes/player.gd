extends CharacterBody2D
@onready var sprite = $Sprite

@export var moveSpeed = 250
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0
@export var bulletSpeed = 400
@export var upgrades: Array[String] = []
@export var max_health = 10
var health = 10

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
	
	if "Extra Health" in upgrades:
		max_health += 2
		
	health = max_health

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
	
	var angle = input_vector.angle()
	if velocity.x < 0:
		sprite.flip_h=false
	elif velocity.x > 0:
		sprite.flip_h=true
	
	velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	if velocity.x > 0 || velocity.y > 0:
		if angle >= -PI/8 and angle < PI/8:
			sprite.play("Running")
		elif angle >= PI/8 and angle < 3*PI/8:
			sprite.play("RunningSideDown")
		elif angle >= 3*PI/8 and angle < 5*PI/8:
			sprite.play("RunningDown")
		elif angle >= 5*PI/8 and angle < 7*PI/8:
			sprite.play("RunningSideDown")
		elif angle >= PI - PI/8 or angle < -PI + PI/8:
			sprite.play("Running")
		elif angle >= -7*PI/8 and angle < -5*PI/8:
			sprite.play("RunningSideUp")
		elif angle >= -5*PI/8 and angle < -3*PI/8:
			sprite.play("RunningUp")
		elif angle >= -3*PI/8 and angle < -PI/8:
			sprite.play("RunningSideUp")
	else:
		if angle >= -PI/8 and angle < PI/8:
			sprite.play("StandingSide")
		elif angle >= PI/8 and angle < 3*PI/8:
			sprite.play("StandingSideDown")
		elif angle >= 3*PI/8 and angle < 5*PI/8:
			sprite.play("Standing")
		elif angle >= 5*PI/8 and angle < 7*PI/8:
			sprite.play("StandingSideDown")
		elif angle >= PI - PI/8 or angle < -PI + PI/8:
			sprite.play("StandingSide")
		elif angle >= -7*PI/8 and angle < -5*PI/8:
			sprite.play("StandingSideUp")
		elif angle >= -5*PI/8 and angle < -3*PI/8:
			sprite.play("StandingUp")
		elif angle >= -3*PI/8 and angle < -PI/8:
			sprite.play("StandingSideUp")
			
	print(angle)
	
	if Input.is_action_just_pressed("DebugAction") and deviceID==0:
		nextLevel()
	if Input.is_action_just_pressed("Action"+suffix) and "Battery Bullets" in upgrades:
		summonBullet()
	if Input.is_action_just_pressed("Jump"+suffix) and "Slash Attack" in upgrades:
		slashAttack()
		
	$HealthBar.max_value = max_health
	$HealthBar.value = health

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
