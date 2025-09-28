extends CharacterBody2D
@onready var sprite = $Sprite

@export var moveSpeed = 250
@export var acceleration = 2000
@export var friction = 1000
@export var deviceID = 0
@export var bulletSpeed = 400
@export var upgrades: Array[String] = []
@export var max_health = 2
@export var dashSpeed = 300
var health = 2
var dashing=0
var dashVector=Vector2.ZERO
var canDash=true
var level=0
@export var movement_deadzone: float = 0.15
var bullet = load("res://Scenes/bullet.tscn")
var last_input_vector = Vector2.ZERO
var last_look_direction = Vector2.LEFT

func _ready():
	
	GlobalState.players_alive += 1
	
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
	
	if "Less Health" in upgrades:
		max_health -= 1
	
	if "Extra Health" in upgrades:
		max_health += 2
		
	if "Move Speed" in upgrades:
		moveSpeed += 30
		
	if "Larger Slash" in upgrades:
		$SlashArea.scale = Vector2.ONE * 2
	
	if "Faster Slash" in upgrades:
		$SlashTimer.wait_time = 0.1
		
	if "Faster Firerate" in upgrades:
		$BulletTimer.wait_time = 0.2
		
	if "Slower Attacks" in upgrades:
		$BulletTimer.wait_time += 0.1
		$SlashTimer.wait_time += 0.1
		
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
		last_look_direction = input_vector
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
			
	
	if Input.is_action_just_pressed("DebugAction") and deviceID==0:
		nextLevel()
	if Input.is_action_just_pressed("Action"+suffix) and "Battery Bullets" in upgrades:
		if $BulletTimer.is_stopped():
			$BulletTimer.start()
			summonBullet()
	if Input.is_action_just_pressed("Jump"+suffix) and "Slash Attack" in upgrades:
		if $SlashTimer.is_stopped():
			$SlashTimer.start()
			slashAttack()
	if Input.is_action_just_pressed("Dash"+suffix) and "Dash Ability" in upgrades:
		if input_vector.length() > movement_deadzone and canDash:
			canDash=false
			if "Long Dash" in upgrades:
				dashSpeed=500
			dashing=10
			$DashTimer.start()
			dashVector=input_vector
		
	$HealthBar.max_value = max_health
	$HealthBar.value = health
	
	if health <= 0:
		GlobalState.players_alive -= 1
		var grave = load("res://Scenes/tombstone.tscn").instantiate()
		get_parent().add_child(grave)
		grave.global_position = global_position
		queue_free()
		if GlobalState.players_alive <= 0:
			GlobalState.spawners_remaining = 0
			get_tree().reload_current_scene()
	if dashing>0:
		dashing-=1
		velocity=dashVector*dashSpeed
		
	
	move_and_slide()
	
func damage(amount):
	if dashing>0 and ["Dash Invincibility" in upgrades]:
		return
	health -= amount
	damage_flash()

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
	newBullet.direction = last_look_direction
	newBullet.rotation = last_look_direction.angle()
	newBullet.modifier = bulletSpeed
	get_parent().add_child(newBullet)
func nextLevel() -> void:
	var scene = load("res://Scenes/upgrades.tscn").instantiate()
	get_tree().root.add_child(scene)
	scene.get_node("Camera").make_current()
	scene.get_node("PlayerMouse").level=level
	get_parent().queue_free()


func _on_bullet_timer_timeout():
	if Input.is_action_pressed("Action"+str(deviceID)) and "Faster Firerate" in upgrades:
		summonBullet()
		$BulletTimer.start()


func _on_dash_timer_timeout() -> void:
	canDash=true
