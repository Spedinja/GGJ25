extends Area2D

@export var x_speed : int = 400
@export_range(0, 1080, 2) var y_offset_radius : int = 300
@export var cooldown : float = 5

@onready var timer: Timer = $Timer

var current_speed : int
var y_starting_position

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	timer.wait_time = cooldown
	timer.connect("timeout", Callable(self, "_on_cooldown_over"))
	current_speed = x_speed
	y_starting_position = position.y

func _process(delta):
	if position.x < -200:
		position.x = 2100
		current_speed = 0
		print("reset timer start")
		timer.start()
	position.x -= current_speed * delta

func _on_area_entered(area):
	if area.has_method("pop_bubble"):
		area.pop_bubble()

func _on_cooldown_over():
	timer.stop()
	current_speed = x_speed
	var max = y_offset_radius/2
	var min = -max
	position.y = y_starting_position + randi_range(min,max)
