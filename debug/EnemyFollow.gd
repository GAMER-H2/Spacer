extends PathFollow2D

export var speed = 150
var jobDone = false
var enemyType = "basic"
var tier = 1
onready var basicEnemy = preload("res://enemies/BasicEnemy.tscn")
onready var turretEnemy = preload("res://enemies/TurretEnemy.tscn")
onready var rammerEnemy = preload("res://enemies/RammerEnemy.tscn")
onready var advanceEnemy = preload("res://enemies/AdvanceEnemy.tscn")

func _ready():
	var enemy
	if (enemyType == "basic"):
		enemy = basicEnemy.instance()
	elif (enemyType == "turret"):
		enemy = turretEnemy.instance()
	elif (enemyType == "rammer"):
		enemy = rammerEnemy.instance()
	elif (enemyType == "advancer"):
		enemy = advanceEnemy.instance()
	enemy.tier = tier
	add_child(enemy)

func _process(delta):
	set_offset(get_offset() + speed * delta)
	
	if (get_child_count() != 0 and get_unit_offset() == 1 and !jobDone):
		get_child(0).state = "ai"
		jobDone = true
