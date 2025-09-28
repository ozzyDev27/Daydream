extends Node2D

var dialogues = [
	"Lets not forget our upgrades!",
	"Drag the blocks into the cells to become stronger!",
	"Press X or 'L' to move the blocks",
]
var dialoguesAmount = 0

func _ready() -> void:
	# Show the first dialogue immediately
	$Dialogue1.bbcode_text = dialogues[dialoguesAmount]

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Jump"):
		if dialoguesAmount < len(dialogues) - 1:
			dialoguesAmount += 1
			$AnimationPlayer.play("text scroll")
			$Dialogue1.bbcode_text = dialogues[dialoguesAmount]
		else:
			self.hide()
