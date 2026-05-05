extends Node2D

@onready var cursor: AnimatedSprite2D = $Cursor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# SignalManager.money_changed.connect(_on_bubble_area_cash_changed)
	SignalManager.machine_unlocked.connect(on_first_unlock)
	cursor.play("default")

func on_first_unlock():
	var parent = self.get_parent()
	var tutorial2 = load("res://scenes/tutorial/tutorial_2.tscn") as PackedScene
	parent.add_child(tutorial2.instantiate())
	queue_free()

func save_state() -> Dictionary:
	var save_dict = { 
		"filename" : self.get_path(), 
		"parent" : get_parent().get_path(), 
		"tutorial_completed" : SignalManager.tutorial_completed, 
		} 
	return save_dict

func load_state_withDict(data: Dictionary) -> void:
	if data.get("tutorial_completed",true):
		SignalManager.tutorial_completed = true
	else:
		SignalManager.tutorial_completed = false
