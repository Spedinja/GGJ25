extends Node

var currentLvl = 0
var maxLvl = 3
## Array that holds the Unlock & Upgrade Costs for all Bubble Machines.
@export var arrUpgradeCosts: Array[Array] #only use integer plox
@onready var arrButtons: Array=[
	$ShopContainer/btnUpgrade1,
	$ShopContainer/btnUpgrade2,
	$ShopContainer/btnUpgrade3,
	$ShopContainer/btnUpgrade4,
	$ShopContainer/btnUpgrade5,
	$ShopContainer/btnUpgrade6,
	$ShopContainer/btnUpgrade7
]
@onready var arrLabels: Array=[
	$PriceLabels/Machine1Price, 
	$PriceLabels/Machine2Price, 
	$PriceLabels/Machine3Price, 
	$PriceLabels/Machine4Price, 
	$PriceLabels/Machine5Price, 
	$PriceLabels/Machine6Price, 
	$PriceLabels/Machine7Price
]
@onready var arrSpawns: Array=[
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_1", 
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_2", 
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_3", 
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_4", 
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_5", 
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_6", 
	$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_7"
]

enum shop_states {cant_unlock,can_unlock,cant_upgrade,can_upgrade,max}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.money_changed.connect(_on_bubble_area_cash_changed)
	setupLabels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_btn_upgrade_1_pressed() -> void:
	#currentLvl = arrCurrLevel[0]
	#if currentLvl < maxLvl:
		#print(currentLvl)
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_1".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[0][currentLvl])*-1)
		#currentLvl = currentLvl+1
		#if currentLvl < 3: arrLabels[0].text = str(arrUpgradeCosts[0][currentLvl], "$")
		#arrCurrLevel[0] = currentLvl
	btnUpgradePressed(0)

func btnUpgradePressed(btnNum: int)->void:
	var currMoney = $"../../BubbleArea".getCash()
	currentLvl = arrSpawns[btnNum].getLevel()
	# If the player doesn't have enough money to unlock or upgrade a Machine, 
	# play a Sound, then return
	if currMoney < arrUpgradeCosts[btnNum][currentLvl+1]:
		if currentLvl+1 == 0:
			SignalManager.cant_unlock.emit()
		else:
			SignalManager.cant_upgrade.emit()
		return
	if currentLvl+1 <= maxLvl:
		currentLvl = arrSpawns[btnNum].levelUp()
		if currentLvl < 2:
			arrLabels[btnNum].text = str(arrUpgradeCosts[btnNum][currentLvl+1], "$")
		else:
			arrLabels[btnNum].text = "Max"
		SignalManager.money_changed.emit((arrUpgradeCosts[btnNum][currentLvl])*-1)
	for spawner in arrSpawns:
		if spawner.getLevel() < 2:
			return
	SignalManager.fully_upgraded_everything.emit()
	print("All Machines Maxed out")

		
func updateShop()-> void:
	var tmpCounter = 0
	var current_spawner_level: int
	var currMoney = $"../../BubbleArea".getCash()
	var current_shop_button: TextureButton
	var lbl: Label
	for spawn in arrSpawns:
		current_spawner_level = spawn.getLevel()+1 
		current_shop_button = arrButtons[tmpCounter]
		# State: Max
		if current_spawner_level > 2:
			set_button_textures(tmpCounter, shop_states.max)
			current_shop_button.disabled = true
			#print("Spawner " + str(tmpCounter) + " - State: Max")
		# State: Can't Unlock
		elif current_spawner_level == 0 and (currMoney < arrUpgradeCosts[tmpCounter][current_spawner_level]):
			set_button_textures(tmpCounter, shop_states.cant_unlock)
			#current_shop_button.disabled = true
			#print("Spawner " + str(tmpCounter) + " - State: Locked")
		# State: Can Unlock
		elif current_spawner_level == 0 and (currMoney >= arrUpgradeCosts[tmpCounter][current_spawner_level]):
			set_button_textures(tmpCounter, shop_states.can_unlock)
			current_shop_button.disabled = false
			#print("Spawner " + str(tmpCounter) + " - State: Can Unlock")
		# State: Upgradeable
		elif (current_spawner_level > 0 and current_spawner_level < 3) && (currMoney >= arrUpgradeCosts[tmpCounter][current_spawner_level]):
			set_button_textures(tmpCounter, shop_states.can_upgrade)
			#current_shop_button.disabled = false
			#print("Spawner " + str(tmpCounter) + " - State: Upgradable")
		# State: Can't Upgrade
		elif (current_spawner_level > 0 and current_spawner_level < 3) && (currMoney < arrUpgradeCosts[tmpCounter][current_spawner_level]):
			set_button_textures(tmpCounter, shop_states.cant_upgrade)
			#current_shop_button.disabled = true
			#print("Spawner " + str(tmpCounter) + " - State: Cannot Upgrade")
			
			if spawn.getLevel() == 3:
				lbl = arrLabels[tmpCounter]
				lbl.visible = false
				lbl.text= "$"
		# State: Max - Not Yet Implemented
		tmpCounter += 1
	#print("-----------------")


func _on_bubble_area_cash_changed(value: Variant) -> void:
	updateShop()
	#updateLabels()

func set_button_textures(spawner_nr: int, button_type: shop_states):
	var path = "res://sprites/MachineIcons/"
	match button_type:
		shop_states.cant_unlock:
			path += "Icon_Machine_Locked.png"
		shop_states.can_unlock:
			path += "Unlockable/Icon_Machine_" + str(spawner_nr+1) + "_Unlockable.png"
		shop_states.cant_upgrade:
			path += "Basic/Icon_Machine_ " + str(spawner_nr+1) + "b.png"
		shop_states.can_upgrade:
			path += "Upgradeable/Icon_Machine_" + str(spawner_nr+1) + "_Upgradable.png"
		shop_states.max:
			# TODO: New Icon
			path += "Basic/Icon_Machine_ " + str(spawner_nr+1) + "b.png"
		_:
			print("Error in \"set_button_textures\": There is no such Button-Type/Shop-State \"" + str(button_type) + "\"")

	var new_sprite = load(path)
	arrButtons[spawner_nr].texture_normal = new_sprite
	arrButtons[spawner_nr].texture_disabled = new_sprite

func _on_btn_upgrade_2_pressed() -> void:
	#currentLvl = arrCurrLevel[1]
	#if currentLvl < maxLvl:
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_2".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[1][currentLvl])*-1)
		#currentLvl = currentLvl +1
		#if currentLvl < 3: arrLabels[1].text = str(arrUpgradeCosts[1][currentLvl], "$")
		#arrCurrLevel[1] = currentLvl
	btnUpgradePressed(1)

func _on_btn_upgrade_3_pressed() -> void:
	#currentLvl = arrCurrLevel[2]
	#if currentLvl < maxLvl:
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_3".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[2][currentLvl])*-1)
		#currentLvl = currentLvl +1
		#if currentLvl < 3: arrLabels[2].text = str(arrUpgradeCosts[2][currentLvl], "$")
		#arrCurrLevel[2] = currentLvl
	btnUpgradePressed(2)

func _on_btn_upgrade_4_pressed() -> void:
	#currentLvl = arrCurrLevel[3]
	#if currentLvl < maxLvl:
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_4".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[3][currentLvl])*-1)
		#currentLvl = currentLvl +1
		#if currentLvl < 3: arrLabels[3].text = str(arrUpgradeCosts[3][currentLvl], "$")
		#arrCurrLevel[3] = currentLvl
	btnUpgradePressed(3)

func _on_btn_upgrade_5_pressed() -> void:
	#currentLvl = arrCurrLevel[4]
	#if currentLvl < maxLvl:
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_5".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[4][currentLvl])*-1)
		#currentLvl = currentLvl +1
		#if currentLvl < 3: arrLabels[4].text = str(arrUpgradeCosts[4][currentLvl], "$")
		#arrCurrLevel[4] = currentLvl
	btnUpgradePressed(4)

func _on_btn_upgrade_6_pressed() -> void:
	#currentLvl = arrCurrLevel[5]
	#if currentLvl < maxLvl:
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_6".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[5][currentLvl])*-1)
		#currentLvl = currentLvl +1
		#if currentLvl < 3: arrLabels[5].text = str(arrUpgradeCosts[5][currentLvl], "$")
		#arrCurrLevel[5] = currentLvl
	btnUpgradePressed(5)

func _on_btn_upgrade_7_pressed() -> void:
	#currentLvl = arrCurrLevel[6]
	#if currentLvl < maxLvl:
		#$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_7".levelUp(currentLvl)
		#SignalManager.money_changed.emit((arrUpgradeCosts[6][currentLvl])*-1)
		#currentLvl = currentLvl +1
		#if currentLvl < 3: arrLabels[6].text = str(arrUpgradeCosts[6][currentLvl], "$")
		#arrCurrLevel[6] = currentLvl
	btnUpgradePressed(6)
		
func setupLabels()->void:
	var counter = 0
	for lbl in arrLabels:
		lbl.visible = true
		lbl.text= str(arrUpgradeCosts[counter][0], "$")
		counter = counter +1
