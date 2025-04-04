extends Area2D

@export var x_speed : int = 200
@export_range(0, 1080) var y_offset_radius : int
@export var cooldown : float = 10

@onready var timer: Timer = $Timer

var current_speed : int

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	timer.wait_time = cooldown
	timer.connect("timeout", Callable(self, "_on_cooldown_over"))
	current_speed = x_speed

func _process(delta):
	if position.x < -300:
		position.x = 1920
		current_speed = 0
		print("reset timer start")
		timer.start()
	position.x -= current_speed * delta

func _on_area_entered(area):
	if area.has_method("pop_bubble"):
		area.pop_bubble()

func _on_cooldown_over():
	
	current_speed = x_speed
