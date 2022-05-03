extends Area2D

export (int) var speed = 50
export (String, "left", "right", "debug") var state = "left"
export (int, 1, 4) var tier = 1
onready var softCollision = $SoftCollision
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
onready var sprite1 = preload("res://assets/enemies/sprite_ufo0.png")
onready var sprite2 = preload("res://assets/enemies/sprite_ufo1.png")
onready var sprite3 = preload("res://assets/enemies/sprite_ufo2.png")
onready var sprite4 = preload("res://assets/enemies/sprite_ufo3.png")

const defaultPos = Vector2(160,69)
const wanderLimit = 310
const wanderMin = 10
const killLimit = 330
const killMin = -10

var hp = 5
var rng = RandomNumberGenerator.new()
var hangAround = 0
var shootChance = 1500

func _ready( ):
	rng.randomize()
	if (tier == 1):
		hp = 5
		speed = 50
		shootChance = 1500
		$Sprite.set_texture(sprite1)
	elif (tier == 2):
		hp = 10
		speed = 50
		shootChance = 1500
		$Sprite.set_texture(sprite2)
	elif (tier == 3):
		hp = 15
		speed = 50
		shootChance = 1250
		$Sprite.set_texture(sprite3)
	elif (tier == 4):
		hp = 20
		speed = 75
		shootChance = 1000
		$Sprite.set_texture(sprite4)

func _physics_process(delta):
	#global_position.y += speed * delta
	if (state == "left"):
		global_position.x -= speed * delta
		if (global_position.x <= wanderMin and hangAround < 6):
			state = "right"
			hangAround += 1
		elif (global_position.x <= killMin and hangAround >= 6):
			queue_free()
	elif (state == "right"):
		global_position.x += speed * delta
		if (global_position.x >= wanderLimit and hangAround < 6):
			state = "left"
			hangAround += 1
		elif (global_position.x >= killLimit and hangAround >= 6):
			queue_free()
	if (rng.randi_range(1, shootChance) == 1):
		shoot()

func shoot():
	var el = enemyLaser.instance()
	var guns = [$Gun1, $Gun2, $Gun3]
	var selected = rng.randi_range(0, 2)
	el.global_position = guns[selected].global_position
	el.state = "aim"
	var currentScene = get_tree().get_current_scene()
	currentScene.add_child(el)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		if (player != null):
			player.score += 5
		spawnDeathAnim()
		queue_free()
	else:
		spawnHitEffect()

func spawnDeathAnim():
	var enemyDeath = enemyDeathLoad.instance()
	enemyDeath.global_position = global_position
	enemyDeath.play("default")
	get_tree().get_current_scene().call_deferred("add_child", enemyDeath)
	var coin = coinLoad.instance()
	coin.global_position = global_position
	coin.type = "purple"
	get_tree().get_current_scene().call_deferred("add_child", coin)

func spawnHitEffect():
	var hitEffect = $HitEffect
	hitEffect.play("default")
	yield(hitEffect, "animation_finished")
	hitEffect.stop()
	hitEffect.frame = 0

func freeze():
	set_physics_process(false)
	var t = Timer.new()
	t.set_wait_time(3)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	set_physics_process(true)

func turn():
	pass

func _on_UfoEnemy_area_entered(area):
	var player = get_tree().get_current_scene().get_node_or_null("Player")
	if (area is Player and !player.electricField):
		area.take_damage(1)
