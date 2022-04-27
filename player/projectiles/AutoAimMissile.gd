extends Area2D

var speed = 200
var damage = 6
var velocity = Vector2(0,0)
onready var explosionLoad = preload("res://physics/Explosion.tscn")

func _physics_process(delta):
	var target = findClosestEnemy()
	if (target != null):
		var angle = get_angle_to(target.global_position)
		velocity.x = cos(angle)
		velocity.y = sin(angle)
		$Sprite.look_at(target.global_position)
		$Sprite.rotate(deg2rad(90))
		global_position += velocity * speed * delta
	else:
		global_position.y += -speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func spawnExplosion():
	var explosion = explosionLoad.instance()
	explosion.global_position = global_position
	get_tree().get_current_scene().call_deferred("add_child", explosion)

func findClosestEnemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closestEnemy = null
	if (enemies.size() > 0):
		closestEnemy = enemies[0]
		for enemy in enemies:
			if (enemy.global_position.distance_to(global_position) < closestEnemy.global_position.distance_to(global_position)):
				closestEnemy = enemy
	return closestEnemy

func _on_AutoAimMissile_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		spawnExplosion()
		queue_free()
