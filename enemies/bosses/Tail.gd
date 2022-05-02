extends Area2D

export (int) var speed = 100
export (String, "wait", "ai", "dive", "debug") var state = "wait"

const defaultPos = Vector2(160,69)

var wanderPos = Vector2(200,0)
var rng = RandomNumberGenerator.new()
var timer = 0
var diveTime = 2
var diveChance = 500
var controlled = false
var stillCount = 0

func _ready( ):
	rng.randomize()

func _physics_process(delta):
	if (state == "ai"):
		wanderPos.y = global_position.y
		if (rng.randi_range(1, diveChance) == 1):
			state = "dive"
		if (wanderPos.x > global_position.x):
			global_position.x += min(speed * delta, (wanderPos - global_position).length())
		elif (wanderPos.x < global_position.x):
			global_position.x -= min(speed * delta, (wanderPos - global_position).length())
		if (global_position.x == wanderPos.x):
			var targetX = rng.randi_range(10, 310)
			wanderPos = Vector2(targetX, global_position.y)
	elif (state == "dive"):
		timer += delta
		if (timer >= diveTime):
			global_position.y += speed * delta
		if (global_position.x < -100 or global_position.x > 420 or global_position.y < -100 or global_position.y > 340):
			queue_free()

func turn():
	controlled = true
