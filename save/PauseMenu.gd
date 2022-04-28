extends Control

var quitOption = false

func _process(_delta):
	if (visible == true):
		get_tree().paused = true
		if (Input.is_action_just_pressed("ui_down")):
			$Cursor.global_position = $Position2.global_position
			quitOption = true
		if (Input.is_action_just_pressed("ui_up")):
			$Cursor.global_position = $Position1.global_position
			quitOption = false
		if (Input.is_action_just_pressed("ui_cancel")):
			visible = false
			get_tree().paused = false
		if (Input.is_action_just_pressed("ui_accept")):
			if (quitOption):
				get_tree().paused = false
				if (get_tree().change_scene("res://save/TitleScreen.tscn") != OK):
					print("Error: Cannot change scenes")
			else:
				visible = false
				get_tree().paused = false
