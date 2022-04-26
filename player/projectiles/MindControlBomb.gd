extends Area2D

var speed = 100
var damage = 0

func _physics_process(delta):
	global_position.y += -speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func _on_MindControlBomb_area_entered(area):
	if area.is_in_group("enemies"):
		area.turn()
		queue_free()
