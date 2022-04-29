extends Control

var winner = false

func _ready():
	var score = SaveSystem.currentScore
	$Score.text = "Your Score:\n" + str(score)
	if (winner):
		$Title.text = "YOU WIN"
	get_tree().paused = true

func _process(_delta):
	if (Input.is_action_just_pressed("ui_accept")):
		get_tree().paused = false
		if (get_tree().change_scene("res://save/TitleScreen.tscn") != OK):
					print("Error: Cannot change scenes")
