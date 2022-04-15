extends Path2D

var timer = 0
var spawnTime = 2
var enemy = preload("res://debug/EnemyFollow.tscn")

func _process(delta):
	timer = timer + delta
	
	if (timer > spawnTime):
		var newEnemy = enemy.instance()
		add_child(newEnemy)
		timer = 0
