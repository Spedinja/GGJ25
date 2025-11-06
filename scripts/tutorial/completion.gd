extends Node2D

@onready var cursor: AnimatedSprite2D = $Cursor

func _ready() -> void:
	cursor.play()

func _on_texture_button_pressed() -> void:
	queue_free()
