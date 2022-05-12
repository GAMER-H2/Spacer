extends AnimatedSprite

var coinLoad = preload("res://physics/Coin.tscn")
var rng = RandomNumberGenerator.new()
var coinDone = false
onready var sound = $Kaboom

func _ready():
	rng.randomize()
	play("default")
	sound.play()

func _process(_delta):
	if (!coinDone):
		var chance = rng.randi_range(1,4)
		if (chance == 1):
			var coin = coinLoad.instance()
			coin.global_position = global_position
			var coinDecide = rng.randi_range(1,20)
			if (coinDecide <= 8):
				coin.type = "silver"
			elif (coinDecide >= 9 and coinDecide <= 15):
				coin.type = "gold"
			elif (coinDecide >= 16 and coinDecide <= 19):
				coin.type = "blue"
			elif (coinDecide == 20):	
				coin.type = "purple"
			get_tree().get_current_scene().add_child(coin)
		coinDone = true
	yield(self, "animation_finished")
	yield(sound, "finished")
	queue_free()
