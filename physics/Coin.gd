extends Area2D

var type = "silver"
var value = 10
var speed = 50
onready var ding = $Ding

func _ready():
	if (type == "silver"):
		value = 50
		$Silver.visible = true
		$Silver.play("default")
	elif (type == "gold"):
		value = 100
		$Gold.visible = true
		$Gold.play("default")
	elif (type == "blue"):
		value = 250
		$Blue.visible = true
		$Blue.play("default")
	elif (type == "purple"):
		value = 500
		$Purple.visible = true
		$Purple.play("default")

func _physics_process(delta):
	global_position.y += speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240):
		queue_free()


func _on_Coin_area_entered(area):
	if area is Player:
		ding.play()
		visible = false
		area.moneyAdd(value)
		yield(ding, "finished")
		queue_free()
