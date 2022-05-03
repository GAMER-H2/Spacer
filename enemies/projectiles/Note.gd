extends Area2D

var speed = 100

func _physics_process(delta):
	global_position.y += speed * delta
	if (global_position.x < -20 or global_position.x > 340 or global_position.y < -20 or global_position.y > 260):
		queue_free()

func _on_Note_area_entered(area):
	if (area is Player or "Turret" in area.name):
		area.take_damage(1)
		queue_free()
	elif (!area.is_in_group("enemies")):
		area.queue_free()
