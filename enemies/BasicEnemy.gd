extends Area2D

signal dead

export (int) var speed = 75
export (String, "path", "ai", "debug") var state = "path"
export (int, 1, 4) var tier = 1
onready var pathfollow = get_parent()
onready var softCollision = $SoftCollision
signal spawn_enemy_laser(location)
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
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
var positioned = false
var rng = RandomNumberGenerator.new()
var stillCount = 0
var shootChance = 1500

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
	var angle = get_angle_to(defaultPos)
	velocity.x = cos(angle)
	velocity.y = sin(angle)
	global_position += velocity * min(speed * delta, (defaultPos - global_position).length())
	if (angle == get_angle_to(defaultPos)):
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
		emit_signal("dead")
		queue_free()

func _on_BasicEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)

func _on_BasicEnemy_spawn_enemy_laser(location):
	var el = enemyLaser.instance()
	el.global_position = location
	el.state = "down"
	get_tree().get_current_scene().add_child(el)
