extends Node2D

@onready var score = 0
#@onready var bubble_scene = preload("res://scenes/bubble.tscn")
#@onready var timer
var accum_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$SpawnArea/BubbleSpawn/BubbleSpawn_1.unlockSpawner() # Start the timer to spawn bubbles every 2 seconds


func _process(delta):
	#accum_time += delta
	#if accum_time>1:
	#	spawn_bubble()
	#	accum_time = 0
	#if accum_time > 5:
	#	$SpawnArea/BubbleSpawn/BubbleSpawn_2.unlockSpawner() # Start the timer to spawn bubbles every 2 seconds
	pass

func spawn_bubble():
	# Randomize the position where the bubble will spawn
	#var random_position = Vector2(randf_range(0, get_viewport().size.x), randf_range(0, get_viewport().size.y))
	#var point = $SpawnArea/BubbleSpawn/BubbleSpawn_1
	
	#var bubble_instance = bubble_scene.instantiate()
	#if bubble_instance is PackedScene:
	#bubble_instance.position = point.position
	#$SpawnArea/Bubbles.add_child(bubble_instance)
	#else:
	#	print("error no bubble")
	pass

func add_score(points):
	score += points
	# Update the score UI here if necessary
	print("Score: ", score)
