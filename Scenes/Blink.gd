extends Label



func _on_timer_timeout() -> void:
	if self.visible == false:
		show()
	else:
		hide()
