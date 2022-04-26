extends Area2D

var damage = 10
var speed = 0

func _physics_process(_delta):
	global_position = get_tree().get_current_scene().get_node_or_null("Player").gun.global_position

func _on_AtomicRay_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
