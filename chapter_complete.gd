extends Node2D


func _on_timer_timeout() -> void:
	self.show()
	self.z_index=1000000
