extends CharacterBody2D

var random = RandomNumberGenerator.new() 
var randomness=0
func _on_attack_timer_timeout() -> void:
	$AttackTimer.start()
	randomAttack()
	
func randomAttack():
	$ChargeTimer.start()
	$AnimatedSprite2D.play("")
	randomness=(randi() % 3)+1
	$attack.play(str("attack",randomness))



func _on_charge_timer_timeout() -> void:
	for body in $Attack1Area.get_overlapping_bodies():
		if body.is_in_group("players"):
			body.damage(1000000)
