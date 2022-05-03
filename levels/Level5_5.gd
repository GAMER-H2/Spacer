extends Node2D

onready var gameOverScreen = preload("res://save/GameEnd.tscn")
var timer = 0
var set = false
var ended = false
var explosionWait = null
var lastPlayerPos
onready var shopLoad = preload("res://save/Shop.tscn")
onready var explosionLoad = preload("res://physics/Explosion.tscn")

func _ready():
	startLevel()
	$BossPath/BossFollow.global_position.y = -65

func _process(delta):
	if ($StartLabel.visible):
		$BossPath/BossFollow.global_position.y += 65 * delta
	elif (!$StartLabel.visible and !set):
		$BossPath/BossFollow.state = "go"
		set = true
	if (noEnemies() and !ended):
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

func noEnemies():
	if (get_node_or_null("BossPath/BossFollow/TheTWord") != null):
		return false
	else:
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
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	var player = get_node_or_null("Player")
	if (player != null):
		player.saving()
	add_child(shopLoad.instance())
