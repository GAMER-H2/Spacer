extends Area2D

onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var bossProjectile = preload("res://enemies/projectiles/BossProjectile.tscn")
var rng = RandomNumberGenerator.new()
var onLeft = false
var previousPos = 200
var hp = 30

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
			player.score += 1
		queue_free()
