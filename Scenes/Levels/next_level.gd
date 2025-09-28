extends Area2D


func _on_body_entered(body):
	body.touching_next_level = true


func _on_body_exited(body):
	body.touching_next_level = false
