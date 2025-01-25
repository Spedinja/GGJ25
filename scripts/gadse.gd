extends TextureButton

func _pressed():
	SignalManager.pet_cat.emit()
