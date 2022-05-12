extends Area2D

onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var bossProjectile = preload("res://enemies/projectiles/BossProjectile.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
var row1 = [true, false, false, false, true, true, true]
var row2 = [true, true, false, false, false]
var row3 = [false, true, true, false, false, false, false, false, true, true]
var row4 = [false, true, false, false, false, false, true]
var rows = [row1, row2, row3, row4]
var rng = RandomNumberGenerator.new()
var hp = 90
var row = 1
var rotationGoal = 0

func _ready():
	rng.randomize()

func _physics_process(_delta):
	if (rng.randi_range(1,500) == 1):
		switchRow()
	if (rng.randi_range(1,30) == 1):
		shootAndFire()
	if (rad2deg(rotation) < rotationGoal):
		rotate(deg2rad(min(1, rotationGoal)))

func switchRow():
	rotationGoal += 90
	row += 1
	if (row > 4):
		row = 1

func shootAndFire():
	var currentRow = get_node("Row" + str(row))
	var gunChoice = rng.randi_range(1, currentRow.get_child_count())
	var currentRows = rows[row-1]
	if (currentRows[gunChoice-1]):
		fire(currentRow.get_child(gunChoice-1))
	else:
		shoot(currentRow.get_child(gunChoice-1))

func shoot(gun):
	var el = enemyLaser.instance()
	el.global_position = gun.global_position
	el.state = "down"
	get_tree().get_current_scene().add_child(el)

func fire(gun):
	var bp = bossProjectile.instance()
	var randAngle = rng.randi_range(22, 158)
	bp.angle = deg2rad(randAngle)
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
	var hitEffects = [$HitEffect1, $HitEffect2, $HitEffect3, $HitEffect4]
	for hit in hitEffects:
		hit.play("default")
	yield(hitEffects[3], "animation_finished")
	for hit in hitEffects:
		hit.stop()
		hit.frame = 0
