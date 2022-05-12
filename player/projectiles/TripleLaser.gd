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
	if (bolt1 == null or bolt2 == null or bolt3 == null):
		queue_free()
	if (bolt1.get_child_count() != 0):
		bolt1.global_position += velocity1 * -speed * delta
		if (bolt1.global_position.x < 0 or bolt1.global_position.x > 320 or bolt1.global_position.y < 0 or bolt1.global_position.y > 240):
			removeBolt1()
	if (bolt2.get_child_count() != 0):
		bolt2.global_position += velocity2 * -speed * delta
		if (bolt2.global_position.x < 0 or bolt2.global_position.x > 320 or bolt2.global_position.y < 0 or bolt2.global_position.y > 240):
			removeBolt2()
	if (bolt3.get_child_count() != 0):
		bolt3.global_position += velocity3 * -speed * delta
		if (bolt3.global_position.x < 0 or bolt3.global_position.x > 320 or bolt3.global_position.y < 0 or bolt3.global_position.y > 240):
			removeBolt3()
	if (bolt1.get_child_count() == 0 and bolt2.get_child_count() == 0 and bolt3.get_child_count() == 0):
		queue_free()

func removeBolt1():
	bolt1.remove_child($Bolt1/Sprite)
	bolt1.remove_child($Bolt1/CollisionShape2D)

func removeBolt2():
	bolt2.remove_child($Bolt2/Sprite)
	bolt2.remove_child($Bolt2/CollisionShape2D)

func removeBolt3():
	bolt3.remove_child($Bolt3/Sprite)
	bolt3.remove_child($Bolt3/CollisionShape2D)

func _on_Bolt1_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		removeBolt1()

func _on_Bolt2_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		removeBolt2()

func _on_Bolt3_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)
		removeBolt3()
