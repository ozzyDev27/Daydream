extends Node2D

var dialogues = ["*Alert* Hull integrity at 20% Systems Malfunction Imminent. Head to the Escape Pods Immediately",  ]
var dialoguesAmount = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump") && len(dialogues) < dialoguesAmount:
		dialoguesAmount = dialoguesAmount + 1
		$AnimationPlayer.play("text scroll")
		$Dialogue1.bbcode_text = dialogues[dialoguesAmount]
	elif Input.is_action_just_pressed("Jump") && !(len(dialogues) < dialoguesAmount):
		self.hide()


func _on_timer_timeout() -> void:
	$RichTextLabel.show()
	print("hi")
