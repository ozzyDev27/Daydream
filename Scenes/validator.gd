extends Area2D

func _process(delta):
	for thingie in get_overlapping_areas():
		if not thingie.get_overlapping_areas():
			thingie.valid = true
