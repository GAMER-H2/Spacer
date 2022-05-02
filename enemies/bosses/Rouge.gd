extends Area2D

export (int) var speed = 100
export (String, "wait", "ai", "debug") var state = "wait"
var hp = 30
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var bossProjectile = preload("res://enemies/projectiles/BossProjectile.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
var wanderPos = Vector2(200,0)
var rng = RandomNumberGenerator.new()

func _ready( ):
	rng.randomize()

func _physics_process(delta):
	if (rng.randi_range(1,100) == 1):
		shoot()
	if (rng.randi_range(1,200) == 1):
		fire()
	if (state == "ai"):
		wanderPos.y = global_position.y
		if (wanderPos.x > global_position.x):
			global_position.x += min(speed * delta, (wanderPos - global_position).length())
		elif (wanderPos.x < global_position.x):
			global_position.x -= min(speed * delta, (wanderPos - global_position).length())
		if (global_position.x == wanderPos.x):
			var targetX = rng.randi_range(10, 310)
			wanderPos = Vector2(targetX, global_position.y)

func shoot():
	var els = [enemyLaser.instance(), enemyLaser.instance()]
	els[0].global_position = $Gun1.global_position
	els[1].global_position = $Gun2.global_position
	for el in els:
		el.state = "down"
		get_tree().get_current_scene().add_child(el)

func fire():
	var bp = bossProjectile.instance()
	bp.angle = deg2rad(90)
	bp.global_position = $Gun3.global_position
	get_tree().get_current_scene().add_child(bp)

func take_damage(damage):
	hp -= damage
	if (hp <= 0):
		spawnDeathAnim()
		dropLoot()
		queue_free()
	else:
		spawnHitEffect()

func spawnDeathAnim():
	var enemyDeath = enemyDeathLoad.instance()
	enemyDeath.global_position = global_position
	enemyDeath.scale = Vector2(5,5)
	enemyDeath.frames.set_animation_speed("default", 16)
	enemyDeath.play("default")
	get_tree().get_current_scene().call_deferred("add_child", enemyDeath)

func spawnHitEffect():
	var hitEffect = $HitEffect
	hitEffect.play("default")
	yield(hitEffect, "animation_finished")
	hitEffect.stop()
	hitEffect.frame = 0

func dropLoot():
	var coins = [coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance()]
	var minX = (global_position.x - 20) - 5
	var maxX = (global_position.x + 20) + 5
	var minY = (global_position.y - 20) - 5
	var maxY = (global_position.y + 20) + 5
	for coin in coins:
		var targetX = rng.randi_range(minX, maxX)
		var targetY = rng.randi_range(minY, maxY)
		coin.global_position = Vector2(targetX, targetY)
		var typeChance = rng.randi_range(2,3)
		if (typeChance == 2):
			coin.type = "gold"
		elif (typeChance == 3):
			coin.type = "blue"
		get_tree().get_current_scene().call_deferred("add_child", coin)
