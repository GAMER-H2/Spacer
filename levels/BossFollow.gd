extends PathFollow2D

var speed = 100
export (String, "wait", "go") var state = "wait"

func _process(delta):
	if (state == "go"):
		set_offset(get_offset() + speed * delta)
