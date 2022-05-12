extends Area2D

onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var bossProjectile = preload("res://enemies/projectiles/BossProjectile.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
var rng = RandomNumberGenerator.new()
var hp = 60

func _ready():
	rng.randomize()

func _physics_process(_delta):
	if (rng.randi_range(1,1500) == 1):
		shoot()
	if (rng.randi_range(1,200) == 1):
		fire()

func shoot():
	var el = enemyLaser.instance()
	el.global_position = $Gun3.global_position
	el.state = "aim"
	get_tree().get_current_scene().add_child(el)

func fire():
	var bp = bossProjectile.instance()
	var gunChoice = rng.randi_range(1,2)
	var gun
	if (gunChoice == 1):
		gun = $Gun1
	else:
		gun = $Gun2
	var player = get_tree().get_current_scene().get_node_or_null("Player")
	if (player != null):
		bp.angle = gun.get_angle_to(player.global_position)
	bp.global_position = gun.global_position
	get_tree().get_current_scene().add_child(bp)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		if (player != null):
			player.score += 50
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

func spawnHitEffect():
	var hitEffects = [$HitEffect1, $HitEffect2, $HitEffect3]
	for hit in hitEffects:
		hit.play("default")
	yield(hitEffects[2], "animation_finished")
	for hit in hitEffects:
		hit.stop()
		hit.frame = 0

func _on_Tail_area_entered(area):
	if area is Player:
		area.take_damage(1)
