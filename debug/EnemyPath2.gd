extends Path2D

var timer = 0
var spawnTime = 2
var enemy = preload("res://debug/EnemyFollow2.tscn")
var enemyCount = 0
const enemyLimit = 0

func _process(delta):
	timer = timer + delta
	
	if (timer > spawnTime and enemyCount < enemyLimit):
		var newEnemy = enemy.instance()
		add_child(newEnemy)
		timer = 0
		enemyCount += 1
