extends Node2D

func _process(delta):
	$Label.text = ""
	for upgrade in $Interior.get_overlapping_areas():
		if upgrade.valid:
			$Label.text += "\n" + upgrade.upgrade_name
