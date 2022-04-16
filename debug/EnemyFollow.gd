extends PathFollow2D

export var speed = 150

func _process(delta):
	set_offset(get_offset() + speed * delta)
	
	if (get_child_count() != 0 and get_unit_offset() == 1):
		get_child(0).state = "ai"
