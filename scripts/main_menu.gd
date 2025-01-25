extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_btn_start_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/player_area.tscn")


func _on_btn_toggle_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		$VBoxContainer/btnToggleFullScreen.text = str("Toggle Window") 
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		$VBoxContainer/btnToggleFullScreen.text = str("Toggle Fullscreen")

func _on_btn_quit_pressed() -> void:
	get_tree().quit()
