extends Node2D

var spawn_positions = null

var stardust = preload("res://physics/Stardust.tscn")

func _ready():
	randomize()
	spawn_positions = $SpawnPositions.get_children()

func spawn_dust():
	var indexSpawn = randi() % spawn_positions.size()
	var dust = stardust.instance()
	dust.global_position = spawn_positions[indexSpawn].global_position
	add_child(dust)


func _on_SpawnTimer_timeout():
	spawn_dust()
