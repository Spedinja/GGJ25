extends Camera2D

@onready var shop_button : TextureButton = $"../Buttons/btnGoDown"
@onready var to_bubbles_button : TextureButton = $"../Buttons/btnGoUp"

@export var sky_cam_position : Node
@export var cafe_cam_position : Node

var _first_unlock : bool = true

func _ready():
	SignalManager.machine_unlocked.connect(_on_first_unlock)

func _on_to_shop_pressed():
	SignalManager.move_to_shop.emit()
	shop_button.hide()
	MusicPlayer.on_location_switch()
	var shop_button_tween := create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	shop_button_tween.tween_property(self, "position:y", get_viewport_rect().size.y*1.5,1)
	# When Movement to the Shop is finished, un-hide the Up Button in the Shop
	call_deferred("_on_camera_movement_finished", to_bubbles_button, shop_button_tween)

func _on_camera_movement_finished(button : TextureButton, tween : Tween):
	await tween.finished
	button.show()


func _on_to_bubbles_pressed():
	SignalManager.move_to_bubbles.emit()
	to_bubbles_button.hide()
	MusicPlayer.on_location_switch()
	var to_bubbles_button_tween := create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	to_bubbles_button_tween.tween_property(self, "position:y", get_viewport_rect().size.y*0.5,1)
	# When Movement to the Shop is finished, un-hide the Up Button in the Shop
	call_deferred("_on_camera_movement_finished", shop_button, to_bubbles_button_tween)

func _on_first_unlock():
	if not _first_unlock:
		return
	_first_unlock = false
	to_bubbles_button.visible = true
