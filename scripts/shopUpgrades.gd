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

func updateShop()-> void:
	var currMoney = $BubbleArea.getCash
	#for elem in arrCurrLevel():


func _on_bubble_area_cash_changed(value: Variant) -> void:
	updateShop()
