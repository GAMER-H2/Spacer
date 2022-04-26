extends Area2D

export (String, "down", "aim", "debug") var state = "down"
var velocity = Vector2(0,0)
onready var player = get_tree().get_current_scene().get_node_or_null("Player")

var speed = 100

func _ready():
	if (player != null):
		var angle = get_angle_to(player.global_position)
		velocity.x = cos(angle)
		velocity.y = sin(angle)
	else:
		queue_free()

func _physics_process(delta):
	if (state == "down"):
		global_position.y += speed * delta
	elif (state == "aim"):
		global_position += velocity * speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func _on_EnemyLaser_area_entered(area):
	if area is Player:
		area.take_damage(1)
		queue_free()
