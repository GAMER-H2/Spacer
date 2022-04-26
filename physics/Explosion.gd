extends Area2D

onready var animation = $AnimatedSprite
var damage = 2

func _process(_delta):
	animation.play("default")
	yield(animation, "animation_finished")
	queue_free()

func _on_Explosion_area_entered(area):
	if area.is_in_group("enemies"):
		area.take_damage(damage)

func _on_FrozenExplosion_area_entered(area):
	if area.is_in_group("enemies"):
		area.freeze()
