extends Control

func _ready():
	SaveSystem.defaultValues()

func _process(_delta):
	if (Input.is_action_just_pressed("title_start")):
		if (get_tree().change_scene("res://levels/Level1_1.tscn") != OK):
			print("Error: Cannot change scenes")
	if (Input.is_action_just_pressed("title_quit")):
		get_tree().quit()
