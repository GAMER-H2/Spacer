extends Area2D

export (int) var speed = 25
export (String, "path", "ai", "debug") var state = "path"
export (int, 1, 4) var tier = 1
onready var pathfollow = get_parent()
#onready var player := get_tree().get_root().get_node("DebugLevel").get_node_or_null("Player")
onready var player := get_tree().get_current_scene().get_node_or_null("Player")
onready var softCollision = $SoftCollision
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var explosionLoad = preload("res://physics/Explosion.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var baseSprite1 = preload("res://assets/enemies/sprite_turret_enemy0.png")
onready var baseSprite2 = preload("res://assets/enemies/sprite_turret_enemy1.png")
onready var baseSprite3 = preload("res://assets/enemies/sprite_turret_enemy2.png")
onready var baseSprite4 = preload("res://assets/enemies/sprite_turret_enemy3.png")
onready var gunSprite1 = preload("res://assets/enemies/sprite_turret_enemy4.png")
onready var gunSprite2 = preload("res://assets/enemies/sprite_turret_enemy5.png")
onready var gunSprite3 = preload("res://assets/enemies/sprite_turret_enemy6.png")
onready var gunSprite4 = preload("res://assets/enemies/sprite_turret_enemy7.png")

const defaultPos = Vector2(160,69)
const wanderLimitX = 310
const wanderLimitY = 100
const wanderMin = 10

var hp = 4
var velocity = Vector2(0,0)
var wanderPos = Vector2(160,69)
var positioned = true
var rng = RandomNumberGenerator.new()
var shootChance = 500
var controlled = false

func _ready( ):
	rng.randomize()
#	wanderLimitX = global_position.x + 30
#	wanderLimitY = global_position.y + 30
#	if (wanderLimitX > 320): wanderLimitX = 320
#	if (wanderLimitY > 100): wanderLimitY = 100
#	wanderMinX = wanderLimitX - 60
#	wanderMinY = wanderLimitY - 60
	if (tier == 1):
		hp = 4
		speed = 25
		shootChance = 500
		$Sprite.set_texture(baseSprite1)
		$GunSprite.set_texture(gunSprite1)
	elif (tier == 2):
		hp = 6
		speed = 25
		shootChance = 400
		$Sprite.set_texture(baseSprite2)
		$GunSprite.set_texture(gunSprite2)
	elif (tier == 3):
		hp = 8
		speed = 25
		shootChance = 300
		$Sprite.set_texture(baseSprite3)
		$GunSprite.set_texture(gunSprite3)
	elif (tier == 4):
		hp = 10
		speed = 50
		shootChance = 200
		$Sprite.set_texture(baseSprite4)
		$GunSprite.set_texture(gunSprite4)

func _physics_process(delta):
	player = get_tree().get_current_scene().get_node_or_null("Player")
	if (player != null):
		$GunSprite.look_at(player.position)
		$GunSprite.rotate(67.535)
	#global_position.y += speed * delta
	if (state == "path"):
		softCollision.get_node("CollisionShape2D").disabled = true
	if (state == "ai"):
		softCollision.get_node("CollisionShape2D").disabled = false
		wander(delta)
		if (rng.randi_range(1, shootChance) == 1 and player != null):
				shoot()

func goToCentre(delta):
	var centre = defaultPos
	var enemyCheck = findClosestEnemy()
	if (controlled and enemyCheck != null):
		centre = enemyCheck.global_position
		if (softCollision.is_colliding()):
			spawnExplosion()
			controlled = false
	var angle = get_angle_to(centre)
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	global_position += velocity * min(speed * delta, (centre - global_position).length())
	if (angle == get_angle_to(centre)):
		positioned = true

func wander(delta):
	var angle = get_angle_to(wanderPos)
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	if (softCollision.is_colliding()):
		velocity += softCollision.get_push_vector() * delta * 100
	global_position += velocity * min(speed * delta, (wanderPos - global_position).length())
	if (angle == get_angle_to(wanderPos) or softCollision.is_colliding()):
		wanderTo()

func wanderTo():
	var targetX = rng.randf_range((global_position.x - 20) - 5, (global_position.x + 20) + 5)
	var targetY = rng.randf_range((global_position.y - 20) - 5, (global_position.y + 20) + 5)
	if (targetX < wanderMin):
		targetX = wanderMin
	elif (targetX > wanderLimitX):
		targetX = wanderLimitX
	if (targetY < wanderMin):
		targetY = wanderMin
	elif (targetY > wanderLimitY):
		targetY = wanderLimitY
	wanderPos = Vector2(targetX, targetY)

func shoot():
	var el1 = enemyLaser.instance()
	var el2 = enemyLaser.instance()
	el1.global_position = $Gun1.global_position
	el2.global_position = $Gun2.global_position
	el1.state = "aim"
	el2.state = "aim"
	var currentScene = get_tree().get_current_scene()
	currentScene.add_child(el1)
	currentScene.add_child(el2)
	

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		player = get_tree().get_current_scene().get_node_or_null("Player")
		if (player != null):
			player.score += 3
		queue_free()
	else:
		spawnHitEffect()

func spawnDeathAnim():
	var enemyDeath = enemyDeathLoad.instance()
	enemyDeath.global_position = global_position
	enemyDeath.play("default")
	get_tree().get_current_scene().call_deferred("add_child", enemyDeath)

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
	controlled = true
	positioned = false

func spawnExplosion():
	var explosion = explosionLoad.instance()
	explosion.global_position = global_position
	explosion.scale = Vector2(1.5,1.5)
	get_tree().get_current_scene().call_deferred("add_child", explosion)

func findClosestEnemy():
	var enemies = get_tree().get_nodes_in_group("enemies")
	var closestEnemy = null
	if (enemies.size() > 1):
		if (enemies[0] != self):
			closestEnemy = enemies[0]
		else:
			closestEnemy = enemies[1]
		for enemy in enemies:
			if (enemy.global_position.distance_to(global_position) < closestEnemy.global_position.distance_to(global_position) and enemy != self):
				closestEnemy = enemy
	return closestEnemy

func _on_TurretEnemy_area_entered(area):
	player = get_tree().get_current_scene().get_node_or_null("Player")
	if (area is Player and !player.electricField):
		area.take_damage(1)
