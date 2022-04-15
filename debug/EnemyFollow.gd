extends PathFollow2D

export var speed = 100

func _process(delta):
	set_offset(get_offset() + speed * delta)
	
	if (get_node_or_null("BasicEnemy") != null and get_unit_offset() == 1):
		$BasicEnemy.state = "ai"
