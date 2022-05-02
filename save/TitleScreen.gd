extends Control

func _ready():
	SaveSystem.defaultValues()

func _process(_delta):
	if (Input.is_action_just_pressed("title_start")):
		SaveSystem.nextLevel()
	if (Input.is_action_just_pressed("title_quit")):
		get_tree().quit()
