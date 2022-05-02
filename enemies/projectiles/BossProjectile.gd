extends Area2D

var angle = 0
var velocity = Vector2(0,0)
var speed = 100
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
var hp = 5

func _ready():
	velocity.x = cos(angle)
	velocity.y = sin(angle)

func _physics_process(delta):
	global_position += velocity * speed * delta
	rotation_degrees += 1
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func _on_BossProjectile_area_entered(area):
	if (area is Player or "Turret" in area.name):
		area.take_damage(1)
		queue_free()

func take_damage(damage):
	hp -= damage
	if (hp <= 0):
		spawnDeathAnim()
		queue_free()
	else:
		spawnHitEffect()

func spawnDeathAnim():
	var enemyDeath = enemyDeathLoad.instance()
	enemyDeath.global_position = global_position
	enemyDeath.play("default")
	get_tree().get_current_scene().call_deferred("add_child", enemyDeath)

func spawnHitEffect():
	var hitEffect = $HitEffect
	hitEffect.play("default")
	yield(hitEffect, "animation_finished")
	hitEffect.stop()
	hitEffect.frame = 0
