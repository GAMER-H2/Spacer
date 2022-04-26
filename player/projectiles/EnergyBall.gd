extends Area2D

var speed = 200
var damage = 8

func _physics_process(delta):
	global_position.y += -speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func _on_EnergyBall_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		queue_free()
