extends Node2D

#var primaryLaser = preload("res://player/projectiles/PlayerPrimary.tscn")
#var enemyLaser = preload("res://enemies/projectiles/EnemyLaser.tscn")
var score = 0
#var laserTimer = 0
#const laserInterval = 1

#func _process(delta):
#	laserTimer += delta
#
#func _on_Player_spawn_primary(location):
#	if (laserTimer >= laserInterval):
#		var l = primaryLaser.instance()
#		l.global_position = location
#		add_child(l)

func scorer():
	score += 1
	#$Score.text = "SCORE: " + str(score)
