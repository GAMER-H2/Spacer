extends Area2D

signal dead

export (int) var speed = 150
export (String, "path", "ai", "dive", "debug") var state = "path"
onready var pathfollow = get_parent()
onready var softCollision = $SoftCollision

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
var timer = 0
var diveTime = 2
var diveAngle = null

func _ready( ):
	rng.randomize()

func _physics_process(delta):
	#global_position.y += speed * delta
	if (rng.randi_range(1, 1000) == 112):
		state = "dive"
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
	elif (state == "dive"):
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		timer += delta
		if (player != null and timer < diveTime):
			$Sprite.look_at(player.position)
			$Sprite.rotate(67.535)
		elif (player != null and timer >= diveTime and diveAngle == null):
			diveAngle = get_angle_to(player.global_position)
			velocity.x = cos(diveAngle)
			velocity.y = sin(diveAngle)
		if (diveAngle != null):
			global_position += velocity * speed * delta
		if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
			queue_free()

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
	var targetX = rng.randf_range((global_position.x - 50) - 20, (global_position.x + 50) - 20)
	var targetY = rng.randf_range((global_position.y - 50) - 20, (global_position.y + 50) - 20)
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

func _on_RammerEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
