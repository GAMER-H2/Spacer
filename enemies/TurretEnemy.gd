extends Area2D

signal dead

export (int) var speed = 100
var hp = 1

onready var player := get_tree().get_root().get_node("In-Level").get_node("Player")

func _physics_process(delta):
	$GunSprite.look_at(player.position)
	$GunSprite.rotate(67.535)
	global_position.y += speed * delta

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("dead")
		queue_free()

func _on_TurretEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
