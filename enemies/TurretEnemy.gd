extends Area2D

signal dead

export (int) var speed = 25
export (String, "path", "ai", "debug") var state = "path"
onready var pathfollow = get_parent()
#onready var player := get_tree().get_root().get_node("DebugLevel").get_node_or_null("Player")
onready var player := get_tree().get_current_scene().get_node_or_null("Player")
onready var softCollision = $SoftCollision

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

func _on_TurretEnemy_area_entered(area):
	if area is Player:
		area.take_damage(1)
