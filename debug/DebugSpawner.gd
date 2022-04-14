extends Node2D

var spawn_positions = null

#var Enemy = [preload("res://enemies/BasicEnemy.tscn"), preload("res://enemies/TurretEnemy.tscn"), preload("res://enemies/RammerEnemy.tscn"), preload("res://enemies/AdvanceEnemy.tscn"), preload("res://enemies/UfoEnemy.tscn")]
var Enemy = [preload("res://enemies/TurretEnemy.tscn"), preload("res://enemies/RammerEnemy.tscn"), preload("res://enemies/AdvanceEnemy.tscn"), preload("res://enemies/UfoEnemy.tscn")]
#var Enemy = [preload("res://enemies/TurretEnemy.tscn")]

func _ready():
	randomize()
	spawn_positions = $SpawnPositions.get_children()

func spawn_enemy():
	var indexSpawn = randi() % spawn_positions.size()
	var indexEnemy = randi() % Enemy.size()
	var enemy = Enemy[indexEnemy].instance()
	enemy.global_position = spawn_positions[indexSpawn].global_position
	enemy.connect("dead", get_tree().current_scene, "scorer")
	add_child(enemy)


func _on_SpawnTimer_timeout():
	spawn_enemy()
