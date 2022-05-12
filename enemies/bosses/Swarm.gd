extends Area2D

onready var singleSwarmLoad = preload("res://enemies/bosses/SwarmPiece.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
var rng = RandomNumberGenerator.new()
var hp = 70

func _ready():
	rng.randomize()

func _physics_process(_delta):
	if (rng.randi_range(1,50) == 1):
		spawnPiece()

func spawnPiece():
	var singleSwarm = singleSwarmLoad.instance()
	var spawnChoice = rng.randi_range(1,2)
	var spawn
	if (spawnChoice == 1):
		spawn = $SpawnPoint1
	else:
		spawn = $SpawnPoint2
	singleSwarm.global_position = spawn.global_position
	get_tree().get_current_scene().add_child(singleSwarm)

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
	var hitEffect = $HitEffect
	hitEffect.play("default")
	yield(hitEffect, "animation_finished")
	hitEffect.stop()
	hitEffect.frame = 0
