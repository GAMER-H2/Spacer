extends Area2D
class_name Player

signal spawn_primary(location)

onready var gun = $Gun
var speed = 300
var input_vector = Vector2.ZERO
var armour = 1

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	
	global_position += input_vector * speed * delta
	
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
	emit_signal("spawn_primary", gun.global_position)
