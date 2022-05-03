extends Node2D

onready var enemyMatch = preload("res://debug/EnemyFollow.tscn")
onready var ufo = preload("res://enemies/UfoEnemy.tscn")
var spawningFinished = false
onready var gameOverScreen = preload("res://save/GameEnd.tscn")
var timer = 0
onready var explosionLoad = preload("res://physics/Explosion.tscn")
var lastPlayerPos
var explosionWait = null
var ended = false
var set = false
onready var shopLoad = preload("res://save/Shop.tscn")
onready var middleBoss = get_node_or_null("Enemies/BossPath/BossFollow")
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	startLevel()
	if (middleBoss != null):
		middleBoss.global_position.y = -50

func _process(delta):
	if (middleBoss != null):
		if ($StartLabel.visible):
			middleBoss.global_position.y += 50 * delta
		elif (!$StartLabel.visible and !set):
			middleBoss.state = "go"
			set = true
	if (spawningFinished and noEnemies() and !ended):
		$EndLabel.visible = true
		var areThereCoins = false
		var coins = get_children()
		for coin in coins:
			if ("Coin" in coin.name or "EnemyDeath" in coin.name):
				areThereCoins = true
		if (!areThereCoins):
			nextLevel()
			ended = true
	else:
		timer += delta
	if (Input.is_action_just_pressed("pause")):
		$OnTop/PauseMenu.visible = true
	if (noPlayer()):
		if (explosionWait == null):
			spawnExplosion()
		yield(explosionWait, "animation_finished")
		$OnTop.add_child(gameOverScreen.instance())
	if (rng.randi_range(1,10000) == 1):
		var ufoInstance = ufo.instance()
		ufoInstance.global_position = Vector2(340,10)
		ufoInstance.tier = rng.randi_range(1,4)
		add_child(ufoInstance)

func noEnemies():
	var children = $Enemies.get_children()
	for child in children:
		var enemies = child.get_children()
		for enemy in enemies:
			if (enemy is PathFollow2D):
				return false
	return true

func noPlayer():
	var player = get_node_or_null("Player")
	if (player == null):
		return true
	else:
		lastPlayerPos = player.global_position
		return false

func spawnExplosion():
	var explosion = explosionLoad.instance()
	explosion.global_position = lastPlayerPos
	explosion.scale = Vector2(2.5,2.5)
	explosionWait = explosion.get_child(0)
	get_tree().get_current_scene().call_deferred("add_child", explosion)

func startLevel():
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	$StartLabel.visible = false

func nextLevel():
	var toAdd = int(SaveSystem.currentScore / timer)
	SaveSystem.currentScore += toAdd
	var t = Timer.new()
	t.set_wait_time(1.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	var player = get_node_or_null("Player")
	if (player != null):
		player.saving()
	add_child(shopLoad.instance())
