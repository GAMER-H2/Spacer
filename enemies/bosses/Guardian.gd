extends Area2D

onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var bossProjectile = preload("res://enemies/projectiles/BossProjectile.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
var rng = RandomNumberGenerator.new()
var onLeft = false
var previousPos = 200
var hp = 10

func _ready():
	rng.randomize()

func _physics_process(_delta):
	if (rng.randi_range(1,1500) == 1):
		shoot()
	if (previousPos < global_position.x):
		if (!onLeft):
			fire()
		onLeft = true
	elif (previousPos > global_position.x):
		if (onLeft):
			fire()
		onLeft = false
	previousPos = global_position.x

func shoot():
	var el = enemyLaser.instance()
	el.global_position = $Gun.global_position
	el.state = "aim"
	get_tree().get_current_scene().add_child(el)

func fire():
	var bpMultiple = [bossProjectile.instance(), bossProjectile.instance(), bossProjectile.instance(), bossProjectile.instance(), bossProjectile.instance()]
	bpMultiple[0].angle = deg2rad(90)
	if (!onLeft):
		bpMultiple[1].angle = deg2rad(67.5)
		bpMultiple[2].angle = deg2rad(45)
		bpMultiple[3].angle = deg2rad(22.5)
		bpMultiple[4].angle = deg2rad(0)
	else:
		bpMultiple[1].angle = deg2rad(112.5)
		bpMultiple[2].angle = deg2rad(135)
		bpMultiple[3].angle = deg2rad(157.5)
		bpMultiple[4].angle = deg2rad(180)
	var i = 0
	for bpSingle in bpMultiple:
		bpSingle.global_position = $Gun.global_position
		bpSingle.name = "Bp" + str(i+1)
		get_tree().get_current_scene().add_child(bpSingle)
		i += 1

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		if (player != null):
			player.score += 50
		spawnDeathAnim()
		dropLoot()
		queue_free()
		get_parent().queue_free()
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
	var hitEffects = [$HitEffect1, $HitEffect2, $HitEffect3, $HitEffect4]
	for hit in hitEffects:
		hit.play("default")
	yield(hitEffects[3], "animation_finished")
	for hit in hitEffects:
		hit.stop()
		hit.frame = 0
