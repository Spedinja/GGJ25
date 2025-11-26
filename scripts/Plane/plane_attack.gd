extends Area2D
class_name PlaneAttack

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var speed: float = 100
@export var free_at_position = 2500 # 950

func _ready() -> void:
	area_entered.connect(_on_area_entered)
	animation_player.play("sway")

func _process(delta: float) -> void:
	position.y += speed * delta
	if global_position.y > free_at_position:
		queue_free()

func _on_area_entered(area):
	if area.has_method("pop_bubble"):
		area.pop_bubble()
