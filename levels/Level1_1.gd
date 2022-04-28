extends Node2D

onready var enemyMatch = preload("res://debug/EnemyFollow.tscn")
onready var ufo = preload("res://enemies/UfoEnemy.tscn")
var spawningFinished = false
onready var gameOverScreen = preload("res://save/GameEnd.tscn")

func _ready():
	startLevel()

func _process(_delta):
	if (spawningFinished and noEnemies()):
		nextLevel()
	if (Input.is_action_just_pressed("pause")):
		$PauseMenu.visible = true
	if (noPlayer()):
		add_child(gameOverScreen.instance())

func noEnemies():
	var children = $EnemyPath1.get_children() + $EnemyPath2.get_children()
	for child in children:
		if (child is PathFollow2D):
			return false
	return true

func noPlayer():
	var player = get_node_or_null("Player")
	if (player == null):
		return true
	else:
		return false

func startLevel():
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	$StartLabel.visible = false

func nextLevel():
	$EndLabel.visible = true
	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	var player = get_node_or_null("Player")
	if (player != null):
		player.saving()
	if (get_tree().change_scene("res://save/TitleScreen.tscn") != OK):
			print("Error: Cannot change scenes")