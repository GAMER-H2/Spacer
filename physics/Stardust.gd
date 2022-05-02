extends Sprite

func _physics_process(delta):
	global_position.y += 100 * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()
