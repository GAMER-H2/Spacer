extends Node2D

var Laser = preload("res://player/projectiles/PlayerPrimary.tscn")
var score = 0

func _on_Player_spawn_primary(location):
	var l = Laser.instance()
	l.global_position = location
	add_child(l)

func scorer():
	score += 1
	#$Score.text = "SCORE: " + str(score)
