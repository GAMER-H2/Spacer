extends Area2D

signal dead

export (int) var speed = 75
export (String, "path", "ai", "debug") var state = "path"
export (int, 1, 4) var tier = 1
onready var pathfollow = get_parent()
onready var softCollision = $SoftCollision
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
onready var explosionLoad = preload("res://physics/Explosion.tscn")
onready var sprite1 = preload("res://assets/enemies/sprite_advances0.png")
onready var sprite2 = preload("res://assets/enemies/sprite_advances1.png")
onready var sprite3 = preload("res://assets/enemies/sprite_advances2.png")
onready var sprite4 = preload("res://assets/enemies/sprite_advances3.png")

const defaultPos = Vector2(160,69)
const wanderLimitX = 310
const wanderLimitY = 100
const wanderMin = 10

var hp = 4
var velocity = Vector2(0,0)
var wanderPos = Vector2(160,69)
var positioned = false
var rng = RandomNumberGenerator.new()
var stillCount = 0
var shootChance = 1000
var controlled = false

func _ready( ):
	rng.randomize()
	if (tier == 1):
		hp = 4
		speed = 75
		shootChance = 1000
		$Sprite.set_texture(sprite1)
	elif (tier == 2):
		hp = 7
		speed = 100
		shootChance = 900
		$Sprite.set_texture(sprite2)
	elif (tier == 3):
		hp = 10
		speed = 100
		shootChance = 800
		$Sprite.set_texture(sprite3)
	elif (tier == 4):
		hp = 13
		speed = 125
		shootChance = 700
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
		velocity += softCollision.get_push_vector() * delta * 200
	global_position += velocity * min(speed * delta, (wanderPos - global_position).length())
	if (angle == get_angle_to(wanderPos) or softCollision.is_colliding()):
		wanderTo()

func wanderTo():
	var targetX = rng.randf_range((global_position.x - 70) - 30, (global_position.x + 70) + 30)
	var targetY = rng.randf_range((global_position.y - 70) - 30, (global_position.y + 70) + 30)
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
	el1.state = "down"
	el2.state = "down"
	var currentScene = get_tree().get_current_scene()
	currentScene.add_child(el1)
	currentScene.add_child(el2)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("dead")
		queue_free()

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

func _on_AdvanceEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
