extends Node2D

@onready var pause_menu: Control = $Camera2D/PauseMenu

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") and SignalManager.tutorial_completed:  # "ui_cancel" ist standardmäßig die Escape-Taste
		pause_menu.visible = !pause_menu.visible

func _on_continue_pressed():
	close_menu()

func close_menu():
	pause_menu.visible = false

func _on_back_2_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
