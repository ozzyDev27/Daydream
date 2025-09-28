extends Node2D

var dialogues = [".", "Well, our ship is long gone, and we WERE just on our way to clean up earth 2099.", "Lets get cleaning!", "Press Spacebar or \"A\" to slash" ]
var dialoguesAmount = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump") and len(dialogues) < dialoguesAmount:
		dialoguesAmount = dialoguesAmount + 1
		$AnimationPlayer.play("text scroll")
		$Dialogue1.bbcode_text = dialogues[dialoguesAmount]
	elif Input.is_action_just_pressed("Jump") and !(len(dialogues) < dialoguesAmount):
		self.hide()
