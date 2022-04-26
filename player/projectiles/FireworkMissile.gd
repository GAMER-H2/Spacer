extends Area2D

var speed = 200
var damage = 3
onready var explosionLoad = preload("res://physics/Explosion.tscn")

func _physics_process(delta):
	global_position.y += -speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func spawnExplosion():
	var explosion = explosionLoad.instance()
	explosion.global_position = global_position
	explosion.scale = Vector2(2.5,2.5)
	get_tree().get_current_scene().call_deferred("add_child", explosion)

func _on_FireworkMissile_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		spawnExplosion()
		queue_free()
