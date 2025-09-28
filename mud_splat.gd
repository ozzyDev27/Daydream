extends Node2D


func damage(amount):
	queue_free()


func _on_hurtbox_body_entered(body):
	print(body.name)
	if body.is_in_group("players"):
		body.damage(1)
		queue_free()
