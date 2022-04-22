extends Area2D

var speed = 300

func _physics_process(delta):
	global_position.y += -speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func _on_PlayerPrimary_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1)
		queue_free()
