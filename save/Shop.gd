extends Control

onready var positions = [$MainWindow/Pos9, $MainWindow/Pos8, $MainWindow/Pos7, $MainWindow/Pos6, $MainWindow/Pos5, $MainWindow/Pos4, $MainWindow/Pos3, $MainWindow/Pos2, $MainWindow/Pos1]
var primaryValues = [100, 250, 500, 800, 1000, 5000, 10000, 50000]
var secondaryValues = [100, 150, 500, 800, 1000, 2000, 5000, 10000]
var miscValues = [50, 50, 100, 500, 500, 1000, 10000, 100000]
var states = ["primary", "secondary", "misc"]
var stateIndex = 0
var state = states[stateIndex]
var currentPos = 0
var skipLevel = false
var popInSpeed = 400

var money = -1
var primaryLaserIndex = -1
var secondaryIndex = -1
var speed = -1
var laserInterval = -1
var primaryFireRate = -1
var ammo = -1
var maxAmmo = -1
var armour = -1
var electricField = false
var playerPos = Vector2(0,0)
var score = -1

func _ready():
	rect_global_position.y = -240
	currentMisc()
	$Cursor.global_position = positions[currentPos].global_position
	$Cursor.play("default")
	get_tree().paused = true

func _process(delta):
	if (rect_global_position.y != 0):
		rect_global_position.y += min(popInSpeed * delta, (Vector2(0,0) - rect_global_position).length())
	$Money.text = "$ " + str(money)
	if (Input.is_action_just_pressed("ui_down")):
		currentPos -= 1
		if (currentPos <= -1):
			currentPos = 8
		$Cursor.global_position = positions[currentPos].global_position
	if (Input.is_action_just_pressed("ui_up")):
		currentPos += 1
		if (currentPos >= 9):
			currentPos = 0
		$Cursor.global_position = positions[currentPos].global_position
	if (Input.is_action_just_pressed("ui_next")):
		stateIndex += 1
		if (stateIndex > 2):
			stateIndex = 0
		state = states[stateIndex]
		changeStates()
	if (Input.is_action_just_pressed("ui_prev")):
		stateIndex -= 1
		if (stateIndex < 0):
			stateIndex = 2
		state = states[stateIndex]
		changeStates()
	if (Input.is_action_just_pressed("ui_cancel")):
		exit()
	if (Input.is_action_just_pressed("ui_accept")):
		if (currentPos == 0):
			exit()
		elif (state == states[0]):
			var newMoney = money - primaryValues[currentPos-1]
			if (newMoney > 0 and primaryLaserIndex != currentPos-1):
				money = newMoney
				primaryLaserIndex = currentPos-1
		elif (state == states[1]):
			var newMoney = money - secondaryValues[currentPos-1]
			if (newMoney > 0 and secondaryIndex != currentPos-1):
				money = newMoney
				secondaryIndex = currentPos-1
		elif (state == states[2]):
			var newMoney = money - miscValues[currentPos-1]
			if (newMoney > 0):
				money = newMoney
				miscSorter()

func exit():
	get_tree().paused = false
	SaveSystem.saveValues(laserInterval, primaryLaserIndex, primaryFireRate, secondaryIndex, ammo, speed, armour, playerPos, score, money, maxAmmo, electricField)
	SaveSystem.nextLevel()

func currentMisc():
	var loadedValues = SaveSystem.loadValues()
	laserInterval = loadedValues[0]
	primaryLaserIndex = loadedValues[1]
	primaryFireRate = loadedValues[2]
	secondaryIndex = loadedValues[3]
	ammo = loadedValues[4]
	speed = loadedValues[5]
	armour = loadedValues[6]
	playerPos = loadedValues[7]
	score = loadedValues[8]
	money = loadedValues[9]
	maxAmmo = loadedValues[10]
	electricField = loadedValues[11]

func changeStates():
	if (state == states[0]):
		switchToPrimary()
	elif (state == states[1]):
		switchToSecondary()
	elif (state == states[2]):
		switchToMisc()

func switchToPrimary():
	state = "primary"
	$MainWindow/SubTitle.text = "Primary Weapon"
	$MainWindow/Opt1.text = "Atomic Ray"
	$MainWindow/Price1.text = "$50,000"
	$MainWindow/Opt2.text = "Energy Ball"
	$MainWindow/Price2.text = "$10,000"
	$MainWindow/Opt3.text = "Super Triple"
	$MainWindow/Price3.text = "$5,000"
	$MainWindow/Opt4.text = "Super Laser"
	$MainWindow/Price4.text = "$1,000"
	$MainWindow/Opt5.text = "Quad Laser"
	$MainWindow/Price5.text = "$800"
	$MainWindow/Opt6.text = "Triple Laser"
	$MainWindow/Price6.text = "$500"
	$MainWindow/Opt7.text = "Double Laser"
	$MainWindow/Price7.text = "$250"
	$MainWindow/Opt8.text = "Default Laser"
	$MainWindow/Price8.text = "$100"

func switchToSecondary():
	state = "secondary"
	$MainWindow/SubTitle.text = "Secondary Weapon"
	$MainWindow/Opt1.text = "Player Turret"
	$MainWindow/Price1.text = "$10,000"
	$MainWindow/Opt2.text = "Guided Missile"
	$MainWindow/Price2.text = "$5,000"
	$MainWindow/Opt3.text = "Mines"
	$MainWindow/Price3.text = "$2,000"
	$MainWindow/Opt4.text = "Mind Control"
	$MainWindow/Price4.text = "$1,000"
	$MainWindow/Opt5.text = "Firework Missile"
	$MainWindow/Price5.text = "$800"
	$MainWindow/Opt6.text = "Frozen Missile"
	$MainWindow/Price6.text = "$500"
	$MainWindow/Opt7.text = "Super Missile"
	$MainWindow/Price7.text = "$250"
	$MainWindow/Opt8.text = "Default Missile"
	$MainWindow/Price8.text = "$100"

func switchToMisc():
	state = "misc"
	$MainWindow/SubTitle.text = "Miscellaneous"
	$MainWindow/Opt1.text = "Skip Level"
	$MainWindow/Price1.text = "$100,000"
	$MainWindow/Opt2.text = "Electric Field"
	$MainWindow/Price2.text = "$10,000"
	$MainWindow/Opt3.text = "+ Armour"
	$MainWindow/Price3.text = "$1,000"
	$MainWindow/Opt4.text = "+ Max Ammo"
	$MainWindow/Price4.text = "$500"
	$MainWindow/Opt5.text = "+ Laser Speed"
	$MainWindow/Price5.text = "$500"
	$MainWindow/Opt6.text = "Extra Speed"
	$MainWindow/Price6.text = "$100"
	$MainWindow/Opt7.text = "Less Speed"
	$MainWindow/Price7.text = "$50"
	$MainWindow/Opt8.text = "Ammo Refill"
	$MainWindow/Price8.text = "$50"

func miscSorter():
	if (currentPos == 1):
		ammo = maxAmmo
	elif (currentPos == 2):
		speed -= 50
	elif (currentPos == 3):
		speed += 50
	elif (currentPos == 4):
		laserInterval -= 0.05
		primaryFireRate += 10
	elif (currentPos == 5):
		maxAmmo += 10
	elif (currentPos == 6):
		armour += 1
	elif (currentPos == 7):
		if (!electricField):
			electricField = true
		else:
			money += miscValues[currentPos-1]
	elif (currentPos == 8):
		if (!skipLevel):
			SaveSystem.currentLvl += 1
			skipLevel = true
		else:
			money += miscValues[currentPos-1]
