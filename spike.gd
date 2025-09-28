extends Area2D

func _on_body_entered(body: Node2D):
	print(body.name)
	if body.is_in_group("enemy"):
		body.damage(1)
