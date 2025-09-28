extends Node2D

var dialogues = ["*Alert* Hull integrity at 20% Systems Malfunction Imminent. Head to the Escape Pods Immediately", "Amogus yoooooooooooooo" ]
var dialoguesAmount = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		dialoguesAmount = dialoguesAmount + 1
		$AnimationPlayer.play("text scroll")
		$Dialogue1.bbcode_text = dialogues[dialoguesAmount]
