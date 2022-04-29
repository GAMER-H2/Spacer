extends PathFollow2D

var speed = 100
var state = "wait"

func _process(delta):
	if (state == "go"):
		set_offset(get_offset() + speed * delta)
