extends Area2D

export (int) var speed = 75
export (String, "path", "ai", "debug") var state = "path"
export (int, 1, 4) var tier = 1
onready var pathfollow = get_parent()
onready var softCollision = $SoftCollision
signal spawn_enemy_laser(location)
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")
onready var explosionLoad = preload("res://physics/Explosion.tscn")
onready var sprite1 = preload("res://assets/enemies/sprite_basic_enemy0.png")
onready var sprite2 = preload("res://assets/enemies/sprite_basic_enemy1.png")
onready var sprite3 = preload("res://assets/enemies/sprite_basic_enemy2.png")
onready var sprite4 = preload("res://assets/enemies/sprite_basic_enemy3.png")

const defaultPos = Vector2(160,69)
const wanderLimitX = 310
const wanderLimitY = 100
const wanderMin = 10

var hp = 2
var velocity = Vector2(0,0)
var wanderPos = Vector2(160,69)
var positioned = true
var rng = RandomNumberGenerator.new()
var stillCount = 0
var shootChance = 1500
var controlled = false

#var DEBUG_SWITCH = false

func _ready( ):
	rng.randomize()
	if (tier == 1):
		hp = 2
		speed = 75
		shootChance = 1500
		$Sprite.set_texture(sprite1)
	elif (tier == 2):
		hp = 3
		speed = 75
		shootChance = 1250
		$Sprite.set_texture(sprite2)
	elif (tier == 3):
		hp = 4
		speed = 75
		shootChance = 1000
		$Sprite.set_texture(sprite3)
	elif (tier == 4):
		hp = 5
		speed = 100
		shootChance = 750
		$Sprite.set_texture(sprite4)

func _physics_process(delta):
	#global_position.y += speed * delta
	if (rng.randi_range(1, shootChance) == 1):
		shoot()
	if (state == "path"):
		softCollision.get_node("CollisionShape2D").disabled = true
	elif (state == "ai"):
		softCollision.get_node("CollisionShape2D").disabled = false
		var angle = (get_angle_to(wanderPos))
		if (!positioned):
			goToCentre(delta)
		else:
			wander(delta)
			if (angle == get_angle_to(wanderPos)):
				stillCount += 1
			if (stillCount == 5):
				stillCount = 0
				positioned = false

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
	var minX = (global_position.x - 50) - 20
	var maxX = (global_position.x + 50) + 20
	var minY = (global_position.y - 50) - 20
	var maxY = (global_position.y + 50) + 20
	var targetX = rng.randi_range(minX, maxX)
	var targetY = rng.randi_range(minY, maxY)
#	if (!DEBUG_SWITCH):
#		print(str(targetX) + " " + str(targetY))
#		DEBUG_SWITCH = true
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
	emit_signal("spawn_enemy_laser", $Gun.global_position)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		if (player != null):
			player.score += 1
		spawnDeathAnim()
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

func _on_BasicEnemy_area_entered(area):
	var player = get_tree().get_current_scene().get_node_or_null("Player")
	if (area is Player and !player.electricField):
		area.take_damage(1)

func _on_BasicEnemy_spawn_enemy_laser(location):
	var el = enemyLaser.instance()
	el.global_position = location
	el.state = "down"
	get_tree().get_current_scene().add_child(el)
