extends Area2D

var speed = 300
var damage = 3
var angle1 = deg2rad(90)
var angle2 = deg2rad(67.5)
var angle3 = deg2rad(112.5)
var velocity1 = Vector2(0,0)
var velocity2 = Vector2(0,0)
var velocity3 = Vector2(0,0)
var noMore = false
onready var bolt1 = $Bolt1
onready var bolt2 = $Bolt2
onready var bolt3 = $Bolt3
var bolt1Hit = false
var bolt2Hit = false
var bolt3Hit = false

func _ready():
	velocity1.x = cos(angle1)
	velocity1.y = sin(angle1)
	velocity2.x = cos(angle2)
	velocity2.y = sin(angle2)
	velocity3.x = cos(angle3)
	velocity3.y = sin(angle3)
	bolt1.rotate(angle1-deg2rad(90))
	bolt2.rotate(angle2-deg2rad(90))
	bolt3.rotate(angle3-deg2rad(90))

func _physics_process(delta):
	if (bolt1Hit):
		bolt1.remove_child($Bolt1/Sprite)
		bolt1.remove_child($Bolt1/CollisionShape2D)
		bolt1Hit = false
	elif (bolt1 != null):
		bolt1.global_position += velocity1 * -speed * delta
	if (bolt2Hit):
		bolt2.remove_child($Bolt2/Sprite)
		bolt2.remove_child($Bolt2/CollisionShape2D)
		bolt2Hit = false
	elif (bolt2 != null):
		bolt2.global_position += velocity2 * -speed * delta
	if (bolt3Hit):
		bolt3.remove_child($Bolt3/Sprite)
		bolt3.remove_child($Bolt3/CollisionShape2D)
		bolt3Hit = false
	elif (bolt3 != null):
		bolt3.global_position += velocity3 * -speed * delta
	if (global_position.x < 0 or global_position.x > 320 or global_position.y < 0 or global_position.y > 240 and (bolt1 == null and bolt2 == null and bolt3 == null)):
		queue_free()

func _on_Bolt1_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		bolt1Hit = true


func _on_Bolt2_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		bolt2Hit = true


func _on_Bolt3_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		bolt3Hit = true
