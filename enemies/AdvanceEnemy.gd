extends Area2D

signal dead

export (int) var speed = 75
export (String, "path", "ai", "debug") var state = "path"
onready var pathfollow = get_parent()
onready var softCollision = $SoftCollision
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")

const defaultPos = Vector2(160,69)
const wanderLimitX = 310
const wanderLimitY = 100
const wanderMin = 10

var hp = 3
var velocity = Vector2(0,0)
var wanderPos = Vector2(160,69)
var positioned = false
var rng = RandomNumberGenerator.new()
var stillCount = 0

func _ready( ):
	rng.randomize()

func _physics_process(delta):
	#global_position.y += speed * delta
	if (rng.randi_range(1, 1000) == 112):
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
		velocity += softCollision.get_push_vector() * delta * 200
	global_position += velocity * min(speed * delta, (wanderPos - global_position).length())
	if (angle == get_angle_to(wanderPos) or softCollision.is_colliding()):
		wanderTo()

func wanderTo():
	var targetX = rng.randf_range((global_position.x - 70) - 30, (global_position.x + 70) - 35)
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

func _on_AdvanceEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
