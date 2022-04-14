extends Area2D

signal dead

export (int) var speed = 100
var hp = 1
onready var pathfollow = get_parent()

export (String, "path", "ai") var state = "path"

func _physics_process(delta):
	#global_position.y += speed * delta
	rotation = 0
	#pathfollow.offset += speed * delta

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("dead")
		queue_free()

func _on_BasicEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
