extends Control

func _process(_delta):
	var score = SaveSystem.currentScore
	var ammo = SaveSystem.currentAmmo
	var armour = SaveSystem.currentAmrour
	
	$Score.text = "Score: " + str(score)
	$Ammo.text = "Ammo: " + str(ammo)
	$Armour.text = "Armour: " + str(armour)
