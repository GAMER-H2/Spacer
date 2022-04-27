extends Area2D

var hp = 1
onready var explosionLoad = preload("res://physics/Explosion.tscn")
onready var gunPos = $Gun.global_position
onready var player = get_tree().get_current_scene().get_node_or_null("Player")

func _process(_delta):
	if (player != null):
		if (name == "PlayerTurret1"):
			global_position = player.TurretPos1
		if (name == "PlayerTurret2"):
			global_position = player.TurretPos2
	gunPos = $Gun.global_position

func spawnExplosion():
	var explosion = explosionLoad.instance()
	explosion.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", explosion)

func take_damage(damage):
	hp -= damage
	if (hp <= 0):
		if (player != null):
			player.turretNum -= 1
		spawnExplosion()
		queue_free()
