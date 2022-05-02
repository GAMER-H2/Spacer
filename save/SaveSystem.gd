extends Node2D

var savePath = "res://save/player-state.cfg"
var config = ConfigFile.new()
var loadResponse = config.load(savePath)

const lvls = ["res://levels/Level1_1.tscn", "res://levels/Level1_2.tscn", "res://levels/Level1_3.tscn", "res://levels/Level1_4.tscn", "res://levels/Level1_5.tscn",
"res://levels/Level2_1.tscn", "res://levels/Level2_2.tscn", "res://levels/Level2_3.tscn", "res://levels/Level2_4.tscn", "res://levels/Level2_5.tscn",
"res://levels/Level3_1.tscn", "res://levels/Level3_2.tscn", "res://levels/Level3_3.tscn", "res://levels/Level3_4.tscn", "res://levels/Level3_5.tscn",
"res://levels/Level4_1.tscn", "res://levels/Level4_2.tscn", "res://levels/Level4_3.tscn", "res://levels/Level4_4.tscn", "res://levels/Level4_5.tscn",
"res://levels/Level5_1.tscn", "res://levels/Level5_2.tscn", "res://levels/Level5_3.tscn", "res://levels/Level5_4.tscn", "res://levels/Level5_5.tscn",
"res://levels/Level6_1.tscn", "res://levels/Level6_2.tscn", "res://levels/Level6_3.tscn", "res://levels/Level6_4.tscn", "res://levels/Level6_5.tscn",]
var currentLvl = 0

var currentScore = 0
var currentAmmo = 0
var currentAmrour = 0
var currentMoney = 0

func _ready():
	defaultValues()

func saveValues(laserInterval, primaryLaserIndex, primaryFireRate, secondaryIndex, ammo, speed, armour, globalPosition, score, money, maxAmmo, electricField):
	config.set_value("Player", "laserInterval", laserInterval)
	config.set_value("Player", "primaryLaserIndex", primaryLaserIndex)
	config.set_value("Player", "primaryFireRate", primaryFireRate)
	config.set_value("Player", "secondaryIndex", secondaryIndex)
	config.set_value("Player", "ammo", ammo)
	config.set_value("Player", "speed", speed)
	config.set_value("Player", "armour", armour)
	config.set_value("Player", "globalPosition", globalPosition)
	config.set_value("Player", "score", score)
	config.set_value("Player", "money", money)
	config.set_value("Player", "maxAmmo", maxAmmo)
	config.set_value("Player", "electricField", electricField)
	config.save(savePath)

func loadValues():
	var loadedValues = [0, 0, 0, 0, 0, 0, 0, Vector2(0,0), 0, 0, 0, false]
	loadedValues[0] = config.get_value("Player", "laserInterval", 0.5)
	loadedValues[1] = config.get_value("Player", "primaryLaserIndex", 0)
	loadedValues[2] = config.get_value("Player", "primaryFireRate", 0)
	loadedValues[3] = config.get_value("Player", "secondaryIndex", 0)
	loadedValues[4] = config.get_value("Player", "ammo", 5)
	loadedValues[5] = config.get_value("Player", "speed", 200)
	loadedValues[6] = config.get_value("Player", "armour", 1)
	loadedValues[7] = config.get_value("Player", "globalPosition", Vector2(160, 207))
	loadedValues[8] = config.get_value("Player", "score", 0)
	loadedValues[9] = config.get_value("Player", "money", 50)
	loadedValues[10] = config.get_value("Player", "maxAmmo", 15)
	loadedValues[11] = config.get_value("Player", "electricField", false)
	return loadedValues

func defaultValues():
	config.set_value("Player", "laserInterval", 0.5)
	config.set_value("Player", "primaryLaserIndex", 0)
	config.set_value("Player", "primaryFireRate", 0)
	config.set_value("Player", "secondaryIndex", 0)
	config.set_value("Player", "ammo", 5)
	config.set_value("Player", "speed", 200)
	config.set_value("Player", "armour", 1)
	config.set_value("Player", "globalPosition", Vector2(160, 207))
	config.set_value("Player", "score", 0)
	config.set_value("Player", "money", 50)
	config.set_value("Player", "maxAmmo", 15)
	config.set_value("Player", "electricField", false)
	config.save(savePath)
	currentLvl = 0

func nextLevel():
	if (get_tree().change_scene(lvls[currentLvl]) != OK):
			print("Error: Cannot change scenes")
	currentLvl += 1
