extends Node2D

func _process(delta):
	var player_number = str(int(str(name)[4]) + 1)
	$Label.text = "Player " + player_number + ":"
	for upgrade in $Interior.get_overlapping_areas():
		if upgrade.valid:
			$Label.text += "\n" + upgrade.upgrade_name
	
	if name == "Grid0":
		GlobalState.player0upgrades = []
		for upgrade in $Interior.get_overlapping_areas():
			if upgrade.valid:
				GlobalState.player0upgrades.append(upgrade.upgrade_name)
	elif name == "Grid1":
		GlobalState.player1upgrades = []
		for upgrade in $Interior.get_overlapping_areas():
			if upgrade.valid:
				GlobalState.player1upgrades.append(upgrade.upgrade_name)
	elif name == "Grid2":
		GlobalState.player2upgrades = []
		for upgrade in $Interior.get_overlapping_areas():
			if upgrade.valid:
				GlobalState.player2upgrades.append(upgrade.upgrade_name)
	elif name == "Grid3":
		GlobalState.player3upgrades = []
		for upgrade in $Interior.get_overlapping_areas():
			if upgrade.valid:
				GlobalState.player3upgrades.append(upgrade.upgrade_name)
