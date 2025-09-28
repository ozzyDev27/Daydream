extends CharacterBody2D
@export var veloX=3000
@export var veloY=3000
var lastX=0
var lastY=0
var threshold=100
var health = 2
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
		if get_node("../boss").get_node("AnimatedSprite2D").animation=="normal":
			get_node("../boss").get_node("AnimatedSprite2D").play("sad")
		else:
			$"../Player0".queue_free()
			$"../Player1".queue_free()
			$"../Timer".start()
			var chapterend = load("res://chapter_complete.tscn").instantiate()
			get_tree().get_root().call_deferred("add_child", chapterend)
			var camera_node = chapterend.get_node("Camera2D")
			camera_node.call_deferred("make_current")
		queue_free()
