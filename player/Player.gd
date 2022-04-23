extends Area2D
class_name Player

#signal spawn_primary(location)

onready var gun = $Gun
var speed = 300
var input_vector = Vector2.ZERO
var armour = 1
var xLimit = 320
var laserTimer = 0
const laserInterval = 1
var primaryLaser = preload("res://player/projectiles/PlayerPrimary.tscn")

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	laserTimer += delta
	global_position += input_vector * speed * delta
	if (global_position.x > xLimit):
		global_position.x = xLimit
	elif (global_position.x < 0):
		global_position.x = 0
	
	if Input.is_action_just_pressed("primary_shoot"):
		shoot_primary()

func take_damage(damage):
	armour -= damage
	if armour <= 0:
		queue_free()

func _on_Player_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1)

func shoot_primary():
	#emit_signal("spawn_primary", gun.global_position)
	if (laserTimer >= laserInterval):
		var l = primaryLaser.instance()
		l.global_position = gun.global_position
		get_tree().get_current_scene().add_child(l)
