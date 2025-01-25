extends Node

var currentLvl = 0
var maxLvl


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
