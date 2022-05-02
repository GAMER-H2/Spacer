extends Area2D

var angle = 0
var velocity = Vector2(0,0)
var speed = 100
onready var turret = preload("res://player/projectiles/GenerateTurret.tscn")

func _ready():
	velocity.x = cos(angle)
	velocity.y = sin(angle)

func _physics_process(delta):
	global_position += velocity * speed * delta
	rotation_degrees += 1
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()

func _on_BossProjectile_area_entered(area):
	if (area is Player or area == turret):
		area.take_damage(1)
		queue_free()
