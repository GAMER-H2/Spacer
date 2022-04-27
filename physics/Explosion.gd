extends Area2D

onready var animation = $AnimatedSprite
var damage = 2

func _process(_delta):
	animation.play("default")
	yield(animation, "animation_finished")
	queue_free()

func _on_Explosion_area_entered(area):
	if (area.is_in_group("enemies") and $AnimatedSprite.frame < 6):
		area.take_damage(damage)
		var player = get_tree().get_current_scene().get_node_or_null("Player")
		if (player != null):
			player.score += 1

func _on_FrozenExplosion_area_entered(area):
	if area.is_in_group("enemies"):
		area.freeze()
