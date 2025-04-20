extends Node2D

@onready var cursor: AnimatedSprite2D = $Cursor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# SignalManager.money_changed.connect(_on_bubble_area_cash_changed)
	SignalManager.machine_unlocked.connect(on_first_unlock)
	cursor.play("default")

func on_first_unlock():
	var parent = self.get_parent()
	var tut2 = load("res://scenes/tutorial/tutorial_2.tscn") as PackedScene
	parent.add_child(tut2.instantiate())
	queue_free()


func _on_test_pressed() -> void:
	on_first_unlock()
