extends Area2D

signal dead

export (int) var speed = 100
var hp = 1
onready var pathfollow = get_parent()
var velocity = Vector2(0,0)
const defaultPos = Vector2(160,69)
var wanderPos = Vector2(160,69)
const wanderLimitX = 320
const wanderLimitY = 100
#const defaultPosX = 160
#const defaultRangeX = [158, 162]
#const defaultPosY = 69
#const defaultRangeY = [67, 71]
var positioned = false
var rng = RandomNumberGenerator.new()

export (String, "path", "ai", "debug") var state = "path"

func _physics_process(delta):
	#global_position.y += speed * delta
	#rotation = 0
	#pathfollow.offset += speed * delta
	if (state == "ai"):
		if (!positioned):
			var angle = get_angle_to(defaultPos)
			velocity.x = cos(angle)
			velocity.y = sin(angle)
			global_position += velocity * min(speed * delta, (defaultPos - global_position).length())
			if (angle == get_angle_to(defaultPos)):
				positioned = true
		else:
			var angle = get_angle_to(wanderPos)
			velocity.x = cos(angle)
			velocity.y = sin(angle)
			global_position += velocity * min(speed * delta, (wanderPos - global_position).length())
			if (angle == get_angle_to(wanderPos)):
				var targetX = rng.randf_range((global_position.x - 100), (global_position.x + 100)) + 20
				var targetY = rng.randf_range((global_position.y - 100), (global_position.y + 100)) + 20
				if (targetX < 0):
					targetX = 0
				elif (targetX > wanderLimitX):
					targetX = wanderLimitX
				if (targetY < 0):
					targetY = 0
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
