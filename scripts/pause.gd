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

@onready var pause_button: TextureButton = $HUD/PauseButton


func _ready() -> void:
	get_tree().paused = true
	SignalManager.fully_upgraded_everything.connect(_open_congrats_message)
	animation_player.play("PulsatingSun")
	roller_shutter_animation_player.animation_finished.connect(_on_shutter_animation_finished)
	roller_shutter.visible = true

func _process(_delta):
	#if Input.is_action_just_pressed("ui_accept"):
		#SignalManager.bubble_popped.emit(50000)
	if not SignalManager.ingame:
		return
	if Input.is_action_just_pressed("ui_cancel"):
		if credits.visible:
			credits.visible = false
		else:
			_toggle_menu()

func _on_continue_pressed():
	close_menu()

func _on_pause_pressed() -> void:
	_open_menu()

func _toggle_menu():
	@warning_ignore("standalone_ternary")
	close_menu() if pause_menu.visible  else _open_menu()

func _open_menu():
	pause_menu.visible = true
	pause_button.visible = false

func close_menu():
	pause_menu.visible = false
	pause_button.visible = true

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
	get_tree().paused = false
	$HUD/GameStartUp/VBoxContainer.visible = false
	roller_shutter_animation_player.play("roller_shutter")
	GameDataManager.load_game() #load savefile on start

func _on_shutter_animation_finished(_anim_name):
	SignalManager.ingame = true
	print("Signal Manager tutorial completed: ", SignalManager.tutorial_completed)
	if SignalManager.tutorial_completed:
		$"Overlays/Tutorial 1".queue_free()
		$Buttons/btnGoUp.visible = true
	else:
		$"Overlays/Tutorial 1".visible = true
	pause_button.visible = true
	$HUD/Score.visible = true
	$HUD/GameStartUp.queue_free()
	roller_shutter.queue_free()

func _on_startup_credits_pressed() -> void:
	credits.visible = true
	startup_credits_button.release_focus()

func _on_reset_pressed()-> void:
	GameDataManager.reset_game()
