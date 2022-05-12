extends AnimatedSprite

func _process(_delta):
	if (frame == 1):
		$Ouch.play()
