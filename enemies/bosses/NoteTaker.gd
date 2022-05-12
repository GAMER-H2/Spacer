extends Area2D

onready var noteLoad = preload("res://enemies/projectiles/Note.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var coinLoad = preload("res://physics/Coin.tscn")
onready var mainSprite = preload("res://assets/bosses/sprite_notetaker0.png")
var rng = RandomNumberGenerator.new()
var hp = 120
var timer = 1
const time = 1
var go = false

func _ready():
	rng.randomize()

func _physics_process(delta):
	if (go):
		if (timer >= time):
			fireNote()
			timer = 0
		timer += delta

func spriteChange():
	$Sprite.set_texture(mainSprite)
	go = true

func fireNote():
	var note = noteLoad.instance()
	var gunOptions = [$Gun1, $Gun2, $Gun3, $Gun4]
	var gunChoice = rng.randi_range(0,3)
	note.global_position = Vector2(gunOptions[gunChoice].global_position.x, gunOptions[gunChoice].global_position.y + 28)
	get_tree().get_current_scene().add_child(note)

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
	enemyDeath.global_position = $CollisionShape2D.global_position
	enemyDeath.scale = Vector2(5,5)
	enemyDeath.frames.set_animation_speed("default", 16)
	enemyDeath.play("default")
	get_tree().get_current_scene().call_deferred("add_child", enemyDeath)

func dropLoot():
	var coins = [coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance(), coinLoad.instance()]
	var minX = ($CollisionShape2D.global_position.x - 20) - 5
	var maxX = ($CollisionShape2D.global_position.x + 20) + 5
	var minY = ($CollisionShape2D.global_position.y - 20) - 5
	var maxY = ($CollisionShape2D.global_position.y + 20) + 5
	for coin in coins:
		var targetX = rng.randi_range(minX, maxX)
		var targetY = rng.randi_range(minY, maxY)
		coin.global_position = Vector2(targetX, targetY)
		var typeChance = rng.randi_range(2,3)
		if (typeChance == 2):
			coin.type = "blue"
		elif (typeChance == 3):
			coin.type = "purple"
		get_tree().get_current_scene().call_deferred("add_child", coin)

func spawnHitEffect():
	var hitEffects = [$HitEffect1, $HitEffect2, $HitEffect3, $HitEffect4]
	for hit in hitEffects:
		hit.play("default")
	yield(hitEffects[3], "animation_finished")
	for hit in hitEffects:
		hit.stop()
		hit.frame = 0
