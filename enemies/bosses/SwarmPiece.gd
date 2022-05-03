extends Area2D

var speed = 100
var rng = RandomNumberGenerator.new()
var timer = 0
var diveTime = 2
var velocity = Vector2(0,0)
onready var player = get_tree().get_current_scene().get_node_or_null("Player")
var hp = 1
onready var enemyDeathLoad = preload("res://physics/EnemyDeath.tscn")

func _ready( ):
	if (player != null):
		var angle = get_angle_to(player.global_position)
		velocity.x = cos(angle)
		velocity.y = sin(angle)
		look_at(player.position)
		rotate(67.535)
	else:
		queue_free()
	rng.randomize()

func _physics_process(delta):
	global_position += velocity * speed * delta
	if (global_position.x < -100 or global_position.x > 420 or global_position.y < -100 or global_position.y > 340):
		queue_free()

func take_damage(damage):
	hp -= damage
	if (hp <= 0):
		spawnDeathAnim()
		queue_free()

func spawnDeathAnim():
	var enemyDeath = enemyDeathLoad.instance()
	enemyDeath.global_position = global_position
	enemyDeath.scale = Vector2(0.5,0.5)
	enemyDeath.play("default")
	get_tree().get_current_scene().call_deferred("add_child", enemyDeath)

func _on_SwarmPiece_area_entered(area):
	if area is Player:
		area.take_damage(1)
