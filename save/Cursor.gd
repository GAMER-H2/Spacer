extends AnimatedSprite

onready var currentPos = position

func _process(_delta):
	if (get_parent().visible):
		if (currentPos != position):
			$Move.play()
		if Input.is_action_just_pressed("ui_accept"):
			$Accept.play()
		currentPos = position
