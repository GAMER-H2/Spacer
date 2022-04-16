extends Area2D

signal dead

export (int) var speed = 75
export (String, "path", "ai", "debug") var state = "path"
onready var pathfollow = get_parent()

const defaultPos = Vector2(160,69)
const wanderLimitX = 310
const wanderLimitY = 100
const wanderMin = 10

var hp = 1
var velocity = Vector2(0,0)
var wanderPos = Vector2(160,69)
var positioned = false
var rng = RandomNumberGenerator.new()
var stillCount = 0

func _ready( ):
	rng.randomize()

func _physics_process(delta):
	#global_position.y += speed * delta
	var angle = (get_angle_to(wanderPos))
	if (state == "ai"):
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
	global_position += velocity * min(speed * delta, (wanderPos - global_position).length())
	if (angle == get_angle_to(wanderPos)):
		var targetX = rng.randf_range((global_position.x - 50) - 20, (global_position.x + 50) + 20)
		var targetY = rng.randf_range((global_position.y - 50) - 20, (global_position.y + 50) + 20)
		if (targetX < wanderMin):
			targetX = wanderMin
		elif (targetX > wanderLimitX):
			targetX = wanderLimitX
		if (targetY < wanderMin):
			targetY = wanderMin
		elif (targetY > wanderLimitY):
			targetY = wanderLimitY
		wanderPos = Vector2(targetX, targetY)

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		emit_signal("dead")
		queue_free()

func _on_BasicEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
