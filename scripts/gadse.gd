extends TextureButton

@export var _body_parts : Array[Sprite2D]
@export var _squish_duration : float = 0.5
@export var _squish_scale : float = 0.9

func _pressed():
	_squish()
	SignalManager.pet_cat.emit()

func _squish():
	for part in _body_parts:
		if part:
			# Trigger Squish Animation for corresponding body part
			var tween = create_tween()
			tween.tween_property(part, "scale", Vector2.ONE, _squish_duration
			).from(Vector2(_squish_scale, _squish_scale)
			).set_ease(Tween.EASE_OUT
			).set_trans(Tween.TRANS_SINE)
			tween.play()
