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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.money_changed.connect(_on_bubble_area_cash_changed)


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
	var tempNode: TextureButton
	for elem in arrCurrLevel:
		tmpElem = elem
		print(arrButtons[tmpCounter])
		if currMoney >= arrUpgradeCosts[tmpCounter][tmpElem]:
			tempNode =arrButtons[tmpCounter]
			tempNode.disabled = false
		else:
			tempNode =arrButtons[tmpCounter]
			tempNode.disabled = true
		tmpCounter= tmpCounter +1
		break #ToDo

func _on_bubble_area_cash_changed(value: Variant) -> void:
	updateShop()
