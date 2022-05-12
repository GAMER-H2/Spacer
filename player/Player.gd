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
var laserInterval = 0.5
var primaryLaserIndex = 1
var primaryFireRate = 0
var primaryLaserInstance

onready var secondaries = [preload("res://player/projectiles/DefaultMissile.tscn"),
preload("res://player/projectiles/SuperMissile.tscn"),
preload("res://player/projectiles/FireworkMissile.tscn"),
preload("res://player/projectiles/FrozenMissile.tscn"),
preload("res://player/projectiles/MindControlBomb.tscn"),
preload("res://player/projectiles/Mines.tscn"),
preload("res://player/projectiles/AutoAimMissile.tscn"),
preload("res://player/projectiles/GenerateTurret.tscn")]
var missileTimer = 1
const missileInterval = 1
var secondaryIndex = 7
var secondaryFireRate = 0
var secondaryMissileInstance
var ammo = 15
var maxAmmo = 15
var turretNum = 0

onready var gun = $Gun
var speed = 200
var input_vector = Vector2.ZERO
var armour = 1
var xLimit = 320
onready var TurretPos1 = $TurretSpawn1.global_position
onready var TurretPos2 = $TurretSpawn2.global_position
var score = 0
var money = 0
var electricField = false
onready var hitEffectLoad = preload("res://physics/HitEffect.tscn")

func _ready():
	loading()
	ammo += 5
	if (ammo > maxAmmo):
		ammo = maxAmmo

func _physics_process(delta):
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	laserTimer += delta
	missileTimer += delta
	TurretPos1 = $TurretSpawn1.global_position
	TurretPos2 = $TurretSpawn2.global_position
	global_position += input_vector * speed * delta
	if (global_position.x > xLimit):
		global_position.x = xLimit
	elif (global_position.x < 0):
		global_position.x = 0
	
	if (SaveSystem.currentScore < score):
		score += turretNum
	SaveSystem.currentScore = score
	SaveSystem.currentAmmo = ammo
	SaveSystem.currentAmrour = armour
	SaveSystem.currentMoney = money
	
	if (Input.is_action_just_pressed("primary_shoot")):
		shoot_primary()
	if (Input.is_action_just_released("primary_shoot") and primaryLaserIndex == 7):
		remove_atomic_ray()
	if (Input.is_action_just_pressed("secondary_shoot") and ammo > 0):
		if (secondaryIndex != 7):
			shoot_secondary()
		else:
			generate_turret()

func take_damage(damage):
	armour -= damage
	if armour <= 0:
		queue_free()
	else:
		spawnHitEffect()

func spawnHitEffect():
	var hitEffect = $HitEffect
	hitEffect.play("default")
	yield(hitEffect, "animation_finished")
	hitEffect.stop()
	hitEffect.frame = 0

func change_laser(laserNum):
	primaryLaserIndex = laserNum

func change_secondary(secondaryNum):
	secondaryIndex = secondaryNum

func moneyAdd(value):
	money += value
	$Money.text = "+" + str(value)
	if ($Money.visible):
		var t = get_node_or_null("MrTimer")
		t.stop()
		t.set_wait_time(1)
		t.start()
	else:
		$Money.visible = true
		var t = Timer.new()
		t.name = "MrTimer"
		t.set_wait_time(1)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		$Money.visible = false

func _on_Player_area_entered(area):
	if (area.is_in_group("enemies") and electricField):
		area.take_damage(5)

func shoot_primary():
	#emit_signal("spawn_primary", gun.global_position)
	if (laserTimer >= laserInterval):
		if (primaryLaserIndex != 7):
			$LaserSound.play()
		else:
			$AtomicRaySound.play()
		laserTimer = 0
		primaryLaserInstance = primaryLaser[primaryLaserIndex].instance()
		addLaserToScene(primaryLaserInstance, primaryFireRate, gun.global_position)
		if (turretNum > 0):
			primaryLaserInstance = primaryLaser[primaryLaserIndex].instance()
			addLaserToScene(primaryLaserInstance, primaryFireRate, get_tree().get_current_scene().get_node_or_null("PlayerTurret1").gunPos)
			if (turretNum > 1):
				primaryLaserInstance = primaryLaser[primaryLaserIndex].instance()
				addLaserToScene(primaryLaserInstance, primaryFireRate, get_tree().get_current_scene().get_node_or_null("PlayerTurret2").gunPos)

func shoot_secondary():
	if (missileTimer >= missileInterval):
		$MissileSound.play()
		missileTimer = 0
		secondaryMissileInstance = secondaries[secondaryIndex].instance()
		addLaserToScene(secondaryMissileInstance, secondaryFireRate, gun.global_position)
		ammo -= 1

func addLaserToScene(instance, fireRate, pos):
	instance.speed += fireRate
	instance.global_position = pos
	get_tree().get_current_scene().add_child(instance)

func remove_atomic_ray():
	if (primaryLaserInstance != null):
		$AtomicRaySound.stop()
		get_tree().get_current_scene().remove_child(primaryLaserInstance)
		primaryLaserInstance = null

func generate_turret():
	if (turretNum < 2):
		$GenerateTurretSound.play()
		var turret = secondaries[7].instance()
		turret.global_position = global_position
		if (turretNum == 0):
			turret.global_position = $TurretSpawn1.global_position
			turret.name = "PlayerTurret1"
		elif (turretNum == 1):
			if (get_tree().get_current_scene().get_node_or_null("PlayerTurret2") == null):
				turret.global_position = $TurretSpawn2.global_position
				turret.name = "PlayerTurret2"
			else:
				turret.global_position = $TurretSpawn1.global_position
				turret.name = "PlayerTurret1"
		get_tree().get_current_scene().add_child(turret)
		turretNum += 1

func saving():
	SaveSystem.saveValues(laserInterval, primaryLaserIndex, primaryFireRate, secondaryIndex, ammo, speed, armour, global_position, score, money, maxAmmo, electricField)

func loading():
	var loadedValues = SaveSystem.loadValues()
	laserInterval = loadedValues[0]
	laserTimer = loadedValues[0]
	primaryLaserIndex = loadedValues[1]
	primaryFireRate = loadedValues[2]
	secondaryIndex = loadedValues[3]
	ammo = loadedValues[4]
	speed = loadedValues[5]
	armour = loadedValues[6]
	global_position = loadedValues[7]
	score = loadedValues[8]
	money = loadedValues[9]
	maxAmmo = loadedValues[10]
	electricField = loadedValues[11]
