extends Node2D

@onready var pause_menu: Control = $HUD/PauseMenu
@onready var overlays: Node2D = $Overlays
@onready var completion_screen: PackedScene = preload("res://scenes/tutorial/completion.tscn")

@onready var credits: Control = $HUD/Credits
@onready var credits_button: OcTeaButton = $HUD/PauseMenu/VBoxContainer/Credits
@onready var credits_back_button: OcTeaButton = $HUD/Credits/Back
@onready var startup_credits_button: OcTeaButton = $HUD/GameStartUp/VBoxContainer/btnCredits

@onready var animation_player: AnimationPlayer = $Background/Sky_Sun/AnimationPlayer

@onready var roller_shutter: Sprite2D = $Foreground/RollerShutter
@onready var roller_shutter_animation_player: AnimationPlayer = $Foreground/RollerShutter/AnimationPlayer


func _ready() -> void:
	SignalManager.fully_upgraded_everything.connect(_open_congrats_message)
	animation_player.play("PulsatingSun")
	roller_shutter_animation_player.animation_finished.connect(_on_shutter_animation_finished)

func _process(_delta):
	if not SignalManager.ingame:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if credits.visible:
			credits.visible = false
		else:
			pause_menu.visible = !pause_menu.visible

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
	var congrats_message = completion_screen.instantiate()
	overlays.add_child(congrats_message)

func _on_credits_pressed() -> void:
	credits.visible = true
	credits_button.release_focus()

func _on_back_pressed() -> void:
	credits.visible = false
	credits_back_button.release_focus()

func _on_start_game_pressed() -> void:
	$HUD/GameStartUp/VBoxContainer.visible = false
	roller_shutter_animation_player.play("roller_shutter")

func _on_shutter_animation_finished(_anim_name):
	SignalManager.ingame = true
	$"Overlays/Tutorial 1".visible = true
	$HUD/Score.visible = true
	$HUD/GameStartUp.queue_free()
	roller_shutter.queue_free()

func _on_startup_credits_pressed() -> void:
	credits.visible = true
	startup_credits_button.release_focus()
