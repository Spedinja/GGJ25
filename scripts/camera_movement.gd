extends Camera2D

@onready var shop_button = $"../UI/ToShop"  # Reference to the Button node
@onready var to_bubbles_button = $"../UI/ToBubbles"

func _on_to_shop_pressed():
	shop_button.hide()
	print(get_viewport_rect().size.y)
	var shop_button_tween := create_tween().set_ease(Tween.EaseType.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	shop_button_tween.tween_property(self, "position:y", get_viewport_rect().size.y,1)
	# When Movement to the Shop is finished, un-hide the Up Button in the Shop
	call_deferred("_on_camera_movement_finished", to_bubbles_button, shop_button_tween)

func _on_camera_movement_finished(button : TextureButton, tween : Tween):
	await tween.finished
	button.show()


func _on_to_bubbles_pressed() -> void:
	pass # Replace with function body.
