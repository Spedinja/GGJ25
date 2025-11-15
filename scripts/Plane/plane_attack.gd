extends Area2D
class_name PlaneAttack

@export var speed: float = 200

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	position.y += speed * delta
	if global_position.y > 950:
		queue_free()

func _on_area_entered(area):
	if area.has_method("pop_bubble"):
		area.pop_bubble()
