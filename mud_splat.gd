extends Node2D


func _on_hurtbox_area_entered(body: Area2D) -> void:
	if body.is_in_group("players"):
		body.health -= 1
		body.damage_flash()
		queue_free()

func damage(amount):
	queue_free()
