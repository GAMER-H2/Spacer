extends Path2D

var timer = -2
var spawnTime = 0.5
var enemy = preload("res://debug/EnemyFollow.tscn")
var enemyCount = 0
export (int) var enemyLimit = 2
export (String, "basic", "turret", "rammer", "advancer") var enemyType = "basic"
export (int, 1, 4) var tier = 1

func _process(delta):
	timer = timer + delta
	
	if (timer > spawnTime and enemyCount < enemyLimit):
		var newEnemy = enemy.instance()
		newEnemy.enemyType = enemyType
		newEnemy.tier = tier
		add_child(newEnemy)
		timer = 0
		enemyCount += 1
	
	if (enemyCount == enemyLimit):
		get_tree().get_current_scene().spawningFinished = true
		enemyCount += 1
