extends Node2D

var score = 0
var bubble_scene = preload("res://scenes/bubble.tscn")
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = $Timer
	timer.start(2)  # Start the timer to spawn bubbles every 2 seconds

func _process(delta):
	# Update your score display here (if you have one)
	pass

func spawn_bubble():
	# Randomize the position where the bubble will spawn
	var random_position = Vector2(randf_range(0, get_viewport().size.x), randf_range(0, get_viewport().size.y))
	
	var bubble_instance = bubble_scene.instantiate()
	bubble_instance.position = random_position
	add_child(bubble_instance)

func add_score(points):
	score += points
	# Update the score UI here if necessary
	print("Score: ", score)


func _on_timer_timeout() -> void:
	spawn_bubble()
