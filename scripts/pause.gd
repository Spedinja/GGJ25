extends Node2D

@onready var menu = $Camera2D/Control

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):  # "ui_cancel" ist standardmäßig die Escape-Taste
		menu.visible = true

func _on_continue_pressed():
	menu.visible = false
	pass # Replace with function body.

func _on_back_2_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()
	pass # Replace with function body.
