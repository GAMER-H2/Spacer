extends Area2D

var type = "silver"
var value = 10
var speed = 50

func _ready():
	if (type == "silver"):
		value = 10
		$Silver.visible = true
		$Silver.play("default")
	elif (type == "gold"):
		value = 20
		$Gold.visible = true
		$Gold.play("default")
	elif (type == "blue"):
		value = 35
		$Blue.visible = true
		$Blue.play("default")
	elif (type == "purple"):
		value = 50
		$Purple.visible = true
		$Purple.play("default")

func _physics_process(delta):
	global_position.y += speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()


func _on_Coin_area_entered(area):
	if area is Player:
		area.moneyAdd(value)
		queue_free()
