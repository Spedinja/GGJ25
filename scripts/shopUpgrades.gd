extends Node

var currentLvl = 0
var maxLvl = 3
@export var arrUpgradeCosts: Array[Array] #only use integer plox
var arrCurrLevel: Array=[0,0,0,0,0,0,0]
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
	$PriceLabels/Machine1Price, $PriceLabels/Machine2Price, $PriceLabels/Machine3Price, $PriceLabels/Machine4Price, $PriceLabels/Machine5Price, $PriceLabels/Machine6Price, $PriceLabels/Machine7Price
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.money_changed.connect(_on_bubble_area_cash_changed)
	setupLabels()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_btn_upgrade_1_pressed() -> void:
	currentLvl = arrCurrLevel[0]
	if currentLvl < maxLvl:
		print(currentLvl)
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_1".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[0][currentLvl])*-1)
		currentLvl = currentLvl+1
		arrCurrLevel[0] = currentLvl

func updateShop()-> void:
	var tmpCounter = 0
	var tmpElem: int
	var currMoney = $"../../BubbleArea".getCash()
	var tempNode: TextureButton
	var lbl: Label
	for elem in arrCurrLevel:
		tmpElem = elem + 1
		if (tmpElem < 3) && (currMoney - arrUpgradeCosts[tmpCounter][tmpElem])>=0:
			tempNode =arrButtons[tmpCounter]
			tempNode.disabled = false
			lbl = arrLabels[tmpCounter]
			lbl.visible = true
			lbl.text= str(arrUpgradeCosts[tmpCounter][arrCurrLevel[tmpCounter]], "$")
		else:
			tempNode =arrButtons[tmpCounter]
			tempNode.disabled = true
			
			if tmpElem >= 3:
				lbl = arrLabels[tmpCounter]
				lbl.visible = false
				lbl.text= "$"
		tmpCounter= tmpCounter +1


func _on_bubble_area_cash_changed(value: Variant) -> void:
	updateShop()


func _on_btn_upgrade_2_pressed() -> void:
	currentLvl = arrCurrLevel[1]
	if currentLvl < maxLvl:
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_2".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[1][currentLvl])*-1)
		currentLvl = currentLvl +1
		arrCurrLevel[1] = currentLvl


func _on_btn_upgrade_3_pressed() -> void:
	currentLvl = arrCurrLevel[2]
	if currentLvl < maxLvl:
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_3".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[2][currentLvl])*-1)
		currentLvl = currentLvl +1
		arrCurrLevel[2] = currentLvl


func _on_btn_upgrade_4_pressed() -> void:
	currentLvl = arrCurrLevel[3]
	if currentLvl < maxLvl:
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_4".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[3][currentLvl])*-1)
		currentLvl = currentLvl +1
		arrCurrLevel[3] = currentLvl


func _on_btn_upgrade_5_pressed() -> void:
	currentLvl = arrCurrLevel[4]
	if currentLvl < maxLvl:
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_5".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[4][currentLvl])*-1)
		currentLvl = currentLvl +1
		arrCurrLevel[4] = currentLvl


func _on_btn_upgrade_6_pressed() -> void:
	currentLvl = arrCurrLevel[5]
	if currentLvl < maxLvl:
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_6".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[5][currentLvl])*-1)
		currentLvl = currentLvl +1
		arrCurrLevel[5] = currentLvl


func _on_btn_upgrade_7_pressed() -> void:
	currentLvl = arrCurrLevel[6]
	if currentLvl < maxLvl:
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_7".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[6][currentLvl])*-1)
		currentLvl = currentLvl +1
		arrCurrLevel[6] = currentLvl
		
func setupLabels()->void:
	var counter = 0
	for lbl in arrLabels:
		lbl.visible = true
		lbl.text= str(arrUpgradeCosts[counter][0], "$")
		counter = counter +1
