extends Button

@export var save = false

func _on_pressed() -> void:
	if save == true:
		GameDataManager.save_game()
	else:
		GameDataManager.load_game()
	
