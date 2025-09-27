extends CharacterBody2D
# Character Stats
@export var weight = 10
@export var dash = 350
@export var run = 300
@export var airControl = 50
@export var jumpHeight = -430
@export var doubleJumpHeight = -380
@export var gravity = 1000
@export var fallSpeed = 500
@export var traction = 27
@export var extraJumps = 1

@export var playerNum=0
# Variables n Stuff
var id = 0 #Just an ID for multiplayer.
var runFrame = 0 # Changes from dash to run
var lastDir = 0 # For runFrame
var jumpBuffer = false # Guess what this does
var doubleJump = extraJumps # To track if you can use a double jump
var isJumping = false # To check if the player is currently jumping
var fastFalling = false # Check if fast falling
var airBurst=false # Check if airbursting
var canAirBurst=true # Check if player can air burst
var airBurstCooldown=true # A cooldown for airbursting
var airBurstTouchedGround=true # Hard to explain - checks if has touched ground so that canairburst is true even if in the air but only after touching ground once
var airBurstXDir=0 # Horizontal direction for the airburst
var airBurstYDir=0 # Vertical   ^^^^^^^^^^^^^^^^^^^^^^^^^^
var camera=0 # Which camera is broadcasting to the screen: 0=Set Level, 1=Track Player, 2=TODO Normal Camera
var coyote=10 # The coyote time (10 frames, 1/6th of a second)

@onready var sprite = $Sprite
@onready var airBurstTimer=$airBurstTimer
@onready var airBurstChillTimer=$airBurstCooldown
@onready var levelCam=$"../Camera"

var playerData = {}
func _ready():
	pass
func _physics_process(delta):
	# MOVEMENT
	#i think cuz like ettique can mean different things to different be--people and oif its an action that ebenfits you it might not benefit someone else so it becomes your perception of someones moral character but moral cgaracter is sim9lar to identity and like someones internal representation of moral thought and not your persepttion of what their moral thoughts are
	if not is_on_floor():
		coyote-=1
		if Input.is_action_just_pressed("Airburst") and canAirBurst and (Input.get_axis("dirDown","dirUp") or Input.get_axis("dirLeft","dirRight")):
			airBurst=true
			airBurstTimer.start()
			airBurstCooldown=false
			airBurstChillTimer.start()
			airBurstTouchedGround=false
			canAirBurst=false
			airBurstXDir=Input.get_axis("dirLeft", "dirRight")
			airBurstYDir=Input.get_axis("dirUp","dirDown") #reversed because the y direction is reversed
			doubleJump=0 #no more double jumping after you airburst
		else:
			velocity.y = clamp(velocity.y, -10000, fallSpeed)
			velocity.y += gravity * delta
			if Input.is_action_pressed("dirDown"):
				fastFalling = true
	else:
		coyote=10
		doubleJump = extraJumps
		fastFalling = false
		if not canAirBurst:
			airBurstTouchedGround=true
	tryAirBurstReplenish()
	if airBurst:
		velocity.y=270*airBurstYDir
		velocity.x=400*airBurstXDir
	# Checking for dropping through platforms
	if Input.is_action_pressed("dirDown") and (not Input.is_action_pressed("Jump")) and airBurstCooldown:
		collision_mask &= ~(1 << 1)
		collision_mask |= (1 << 0)
	else:
		collision_mask |= (1 << 1)

	# Jumping
	if Input.is_action_pressed("Jump") and coyote>0:
		velocity.y = jumpHeight
		coyote=0
		if airBurst:
			canAirBurst=true
	elif Input.is_action_just_pressed("Jump") and not coyote>0 and doubleJump > 0 and not airBurst:
		coyote=0
		doubleJump -= 1
		velocity.y = doubleJumpHeight
		fastFalling = Input.is_action_pressed("dirDown") # Allows short double jump

	# Horizontal movement
	var direction = Input.get_axis("dirLeft", "dirRight")
	if is_on_floor() and not airBurst:
		if Input.get_axis("dirLeft","dirRight")==1:
			if not Input.is_action_just_pressed("Jump"):
				sprite.flip_h=false
		elif Input.get_axis("dirLeft","dirRight")==-1:
			if not Input.is_action_just_pressed("Jump"):
				sprite.flip_h=true
				
		if Input.is_action_pressed("dirDown"):
			runFrame -= 2
			velocity.x = move_toward(velocity.x,direction * run/2,traction)
		else:
			if lastDir: # Moved last frame
				if direction == lastDir: # Still going
					if runFrame > 12: # 0.2 secs
						velocity.x = direction * run
					else:
						velocity.x = direction * dash
					runFrame += 2
				elif direction == 0: # Slowing down
					velocity.x = move_toward(velocity.x, 0, traction)
					runFrame -= 1
				else: # Switch direction
					if runFrame > 12: # Running
						velocity.x = 0 # Used to continue, but this is for reverse shielding
					else: # Dash, should be able to dash dance
						velocity.x = direction * dash
			else:
				if direction: # Starting a movement
					velocity.x = direction * dash
				else: # Just chilling
					velocity.x = move_toward(velocity.x, 0, traction)
				runFrame -= 1
		runFrame = clamp(runFrame, 0, 20)
	elif not airBurst:
		velocity.x = move_toward(velocity.x, direction * run, airControl)
	lastDir = direction
	move_and_slide()
	
	# ANIMATIONS
	if is_on_floor() and abs(velocity.x)<=20: # Standing Still
		sprite.play("Standing")
	elif airBurst:                            # Airbursting
		sprite.play("Airburst")
	elif not is_on_floor() and velocity.y>0:  # Falling
		sprite.play("Falling")
	elif not is_on_floor() and velocity.y<=0: # Jumping
		sprite.play("Jumping")
	elif is_on_floor() and abs(velocity.x)>20:
		if runFrame>12:                       # Running
			sprite.play("Running")
func airBurstComplete():
	airBurst=false
func airBurstCooldownSet():
	airBurstCooldown=true
	tryAirBurstReplenish()
func tryAirBurstReplenish():
	if airBurstCooldown and airBurstTouchedGround:
		canAirBurst=true
	#im not resetting the xdir and ydir of the airburst cuz i dont think its necessary so pls dont cause bugs
