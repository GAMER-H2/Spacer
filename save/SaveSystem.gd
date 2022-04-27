extends Node2D

var savePath = "res://save/player-state.cfg"
var config = ConfigFile.new()
var loadResponse = config.load(savePath)

func _ready():
	pass

func saveValues(laserInterval, primaryLaserIndex, primaryFireRate, secondaryIndex, ammo, speed, armour, globalPosition):
	config.set_value("Player", "laserInterval", laserInterval)
	config.set_value("Player", "primaryLaserIndex", primaryLaserIndex)
	config.set_value("Player", "primaryFireRate", primaryFireRate)
	config.set_value("Player", "secondaryIndex", secondaryIndex)
	config.set_value("Player", "ammo", ammo)
	config.set_value("Player", "speed", speed)
	config.set_value("Player", "armour", armour)
	config.set_value("Player", "globalPosition", globalPosition)
	config.save(savePath)

func loadValues():
	var loadedValues = [0, 0, 0, 0, 0, 0, 0, Vector2(0,0)]
	loadedValues[0] = config.get_value("Player", "laserInterval", 0.5)
	loadedValues[1] = config.get_value("Player", "primaryLaserIndex", 0)
	loadedValues[2] = config.get_value("Player", "primaryFireRate", 0)
	loadedValues[3] = config.get_value("Player", "secondaryIndex", 0)
	loadedValues[4] = config.get_value("Player", "ammo", 10)
	loadedValues[5] = config.get_value("Player", "speed", 200)
	loadedValues[6] = config.get_value("Player", "armour", 1)
	loadedValues[7] = config.get_value("Player", "globalPosition", Vector2(160, 209))
	return loadedValues
