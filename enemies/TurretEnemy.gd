extends Area2D

signal dead

export (int) var speed = 100
var hp = 1

func _physics_process(delta):
	global_position.y += speed * delta

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("dead")
		queue_free()

func _on_TurretEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
