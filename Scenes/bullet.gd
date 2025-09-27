extends Node2D

const BULLET_SPEED = 500
var direction = Vector2.ZERO
var modifier=1

func _physics_process(delta):
	var movement_vector = Vector2.ZERO
	
	if direction.length_squared() > 0:
		movement_vector = direction.normalized() * modifier
	position.x+=movement_vector.x*delta
	position.y+=movement_vector.y*delta
