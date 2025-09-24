extends Node2D

@onready var pause_menu: Control = $Camera2D/PauseMenu

func _ready() -> void:
	SignalManager.fully_upgraded_everything.connect(_open_congrats_message)

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		pause_menu.visible = !pause_menu.visible
	#if Input.is_action_just_pressed("DEBUG_Money"):
		#SignalManager.bubble_popped.emit(500)

func _on_continue_pressed():
	close_menu()

func close_menu():
	pause_menu.visible = false

func _on_back_2_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _open_congrats_message():
	print("Thank you for helping me out with my shop.")
	pass
