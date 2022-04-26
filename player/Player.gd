extends Area2D
class_name Player

#signal spawn_primary(location)

onready var primaryLaser = [preload("res://player/projectiles/PlayerPrimary.tscn"),
preload("res://player/projectiles/DoubleLaser.tscn"),
preload("res://player/projectiles/TripleLaser.tscn"),
preload("res://player/projectiles/QuadLaser.tscn"),
preload("res://player/projectiles/SuperLaser.tscn"),
preload("res://player/projectiles/SuperTriple.tscn"),
preload("res://player/projectiles/EnergyBall.tscn"),
preload("res://player/projectiles/AtomicRay.tscn")]
var laserTimer = 0.5
const laserInterval = 0.5
var primaryLaserIndex = 7
var primaryFireRate = 0
var primaryLaserInstance

var secondaries = [preload("res://player/projectiles/DefaultMissile.tscn"),
preload("res://player/projectiles/SuperMissile.tscn"),
preload("res://player/projectiles/FireworkMissile.tscn"),
preload("res://player/projectiles/FrozenMissile.tscn"),
preload("res://player/projectiles/MindControlBomb.tscn")]
var missileTimer = 1
var missileInterval = 1
var secondaryIndex = 4
var secondaryFireRate = 0
var secondaryMissileInstance

onready var gun = $Gun
var speed = 300
var input_vector = Vector2.ZERO
var armour = 1
var xLimit = 320

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	laserTimer += delta
	missileTimer += delta
	global_position += input_vector * speed * delta
	if (global_position.x > xLimit):
		global_position.x = xLimit
	elif (global_position.x < 0):
		global_position.x = 0
	
	if Input.is_action_just_pressed("primary_shoot"):
		shoot_primary()
	if (Input.is_action_just_released("primary_shoot") and primaryLaserIndex == 7):
		remove_atomic_ray()
	if (Input.is_action_just_pressed("secondary_shoot")):
		shoot_secondary()

func take_damage(damage):
	armour -= damage
	if armour <= 0:
		queue_free()

func change_laser(laserNum):
	primaryLaserIndex = laserNum

func change_secondary(secondaryNum):
	secondaryIndex = secondaryNum

func _on_Player_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(1)

func shoot_primary():
	#emit_signal("spawn_primary", gun.global_position)
	if (laserTimer >= laserInterval):
		laserTimer = 0
		primaryLaserInstance = primaryLaser[primaryLaserIndex].instance()
		addLaserToScene(primaryLaserInstance, primaryFireRate)

func shoot_secondary():
	if (missileTimer >= missileInterval):
		missileTimer = 0
		secondaryMissileInstance = secondaries[secondaryIndex].instance()
		addLaserToScene(secondaryMissileInstance, secondaryFireRate)

func addLaserToScene(instance, fireRate):
	instance.speed += fireRate
	instance.global_position = gun.global_position
	get_tree().get_current_scene().add_child(instance)

func remove_atomic_ray():
	if (primaryLaserInstance != null):
		get_tree().get_current_scene().remove_child(primaryLaserInstance)
		primaryLaserInstance = null
