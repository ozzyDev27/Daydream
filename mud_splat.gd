extends Node2D


func _on_hurtbox_area_entered(body: Area2D) -> void:
	body.health -= 1
	body.damage_flash()
	queue_free()
