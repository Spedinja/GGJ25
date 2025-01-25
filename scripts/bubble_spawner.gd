extends Node2D

#unlocks
var spawner_unlocked = false

#vars
var bubble_scene = preload("res://scenes/bubble.tscn")
var accum_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawner_unlocked == true:
		accum_time += delta
		if accum_time>1:
			spawn_bubble()
			accum_time = 0

func spawn_bubble():
	var bubble_instance = bubble_scene.instantiate()
	if bubble_instance != null:
		bubble_instance.setBubbleScale(randf_range(1,4))
		bubble_instance.position = position
		$"../../Bubbles".add_child(bubble_instance)
	else:
		print("error no bubble")

func unlockSpawner() -> void:
	spawner_unlocked = true
