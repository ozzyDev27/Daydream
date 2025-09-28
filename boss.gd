extends CharacterBody2D

var random = RandomNumberGenerator.new() 
var randomness=0


func _ready():
	summonDeployables()
	

func summonDeployables():
	var deployableOne = load("res://deployable.tscn").instantiate()
	deployableOne.position.x=-268.0
	deployableOne.position.y=112
	deployableOne.get_node("AnimatedSprite2D").play("1")
	get_parent().add_child(deployableOne)
	var deployableTwo = load("res://deployable.tscn").instantiate()
	deployableTwo.position.x=-268.0
	deployableTwo.position.y=112
	deployableTwo.get_node("AnimatedSprite2D").play("2")
	get_parent().add_child(deployableTwo)

func _on_attack_timer_timeout() -> void:
	$AttackTimer.start()
	randomAttack()
	
func randomAttack():
	$ChargeTimer.start()
	$AnimatedSprite2D.play("")
	randomness=(randi() % 3)+1
	$attack.play(str("attack",randomness))



func _on_charge_timer_timeout() -> void:
	for body in get_node(str("Attack",randomness,"Area")).get_overlapping_bodies():
		if body.is_in_group("players"):
			body.damage(1000000)
			
