extends Node

var currentLvl = 0
var maxLvl = 3
@export var arrUpgradeCosts: Array[Array] #only use integer plox
var arrCurrLevel: Array=[0,0,0,0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_btn_upgrade_1_pressed() -> void:
	if currentLvl <= maxLvl:
		currentLvl += currentLvl
		$"../../BubbleArea/SpawnArea/BubbleSpawn/BubbleSpawn_1".levelUp(currentLvl)
		SignalManager.money_changed.emit((arrUpgradeCosts[0][arrCurrLevel[0]])*-1)

func updateShop()-> void:
	var tmpCounter = 0
	var tmpElem: int
	var currMoney = $"../../BubbleArea".getCash()
	for elem in arrCurrLevel:
		tmpElem = elem
		if currMoney >= arrUpgradeCosts[tmpCounter][tmpElem]:
			tmpCounter= tmpCounter +1
			print(str("btnUpgrade",tmpCounter))
			$ShopContainer/btnUpgrade1.disabled = false
			break

func _on_bubble_area_cash_changed(value: Variant) -> void:
	updateShop()
