extends Area2D

signal dead

export (int) var speed = 25
export (String, "path", "ai", "debug") var state = "path"
onready var pathfollow = get_parent()
#onready var player := get_tree().get_root().get_node("DebugLevel").get_node_or_null("Player")
onready var player := get_tree().get_current_scene().get_node_or_null("Player")
onready var softCollision = $SoftCollision
onready var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")

const defaultPos = Vector2(160,69)
const wanderLimitX = 310
const wanderLimitY = 100
const wanderMin = 10

var hp = 2
var velocity = Vector2(0,0)
var wanderPos = Vector2(160,69)
var positioned = false
var rng = RandomNumberGenerator.new()

func _ready( ):
	rng.randomize()
#	wanderLimitX = global_position.x + 30
#	wanderLimitY = global_position.y + 30
#	if (wanderLimitX > 320): wanderLimitX = 320
#	if (wanderLimitY > 100): wanderLimitY = 100
#	wanderMinX = wanderLimitX - 60
#	wanderMinY = wanderLimitY - 60

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
		if (rng.randi_range(1, 500) == 112 and player != null):
				shoot()

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
	var targetX = rng.randf_range((global_position.x - 20) - 5, (global_position.x + 20) - 10)
	var targetY = rng.randf_range((global_position.y - 20) - 5, (global_position.y + 20) - 10)
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
		emit_signal("dead")
		queue_free()

func _on_TurretEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
