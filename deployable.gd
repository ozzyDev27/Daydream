extends CharacterBody2D
@export var veloX=3000
@export var veloY=3000
var lastX=0
var lastY=0
var threshold=100
var health = 60
func _physics_process(delta: float) -> void:
	velocity.x=veloX*delta
	velocity.y=veloY*delta
	move_and_slide()
	if lastX==round(position.x*threshold)/threshold:
		veloX=-veloX
		velocity.x+=veloX*delta
		print("bounceX")
	if lastY==round(position.y*threshold)/threshold:
		veloY=-veloY
		print("bounceY")
		velocity.y+=veloY*delta
	lastX=round(position.x*threshold)/threshold
	lastY=round(position.y*threshold)/threshold
func damage(a):
	health-=1
	print('test')
	if health<=0:
		queue_free()
