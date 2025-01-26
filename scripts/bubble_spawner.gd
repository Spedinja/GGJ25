extends Node2D

#unlocks
var spawner_unlocked = false

#vars
var bubble_scene = preload("res://scenes/bubble.tscn")
var bubble_scenes = [preload("res://scenes/bubble_1.tscn"),preload("res://scenes/bubble_2.tscn"),preload("res://scenes/bubble_3.tscn"),preload("res://scenes/bubble_4.tscn"),preload("res://scenes/bubble_5.tscn"),preload("res://scenes/bubble_6.tscn"),preload("res://scenes/bubble_7.tscn")]
var accum_time = 0

@export var bubble_spawner_nr : int


#var bubbleScale
@export var bubbleValue: float

#Stats
var currentLvl = -1
var currModifier
@export var arrStats: Array[float]

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
	var bubble_instance = bubble_scenes[bubble_spawner_nr].instantiate()
	if bubble_instance != null:
		#bubble_instance.add_to_group("bubbles") not needed
		#bubbleScale = randf_range(1,4)
		#bubble_instance.setBubbleScale(bubbleScale)
		#bubble_instance.setBubbleValue(bubbleValue*bubbleScale)
		bubble_instance.adjustBubbleValues(currModifier, bubbleValue)
		bubble_instance.position = position
		SignalManager.bubble_popped.disconnect($"../../..".on_bubble_popped.bind(bubble_instance.getBubbleValue()))
		SignalManager.bubble_popped.connect($"../../..".on_bubble_popped.bind(bubble_instance.getBubbleValue()))
		#bubble_instance.bubble_popped.connect($"../../..".on_bubble_popped.bind(bubble_instance.getBubbleValue()))
		$"../../Bubbles".add_child(bubble_instance)
	else:
		print("error no bubble")

func _unlockSpawner() -> void:
	spawner_unlocked = true


func levelUp() -> int:
	SignalManager.machine_level_up.emit()
	_increaseStats()
	if currentLvl == 0:#vorher1
		_unlockSpawner()
	return self.currentLvl
	
func _increaseStats()-> void:
	#get next element from array, adjust on instantiate
	self.currentLvl = self.currentLvl+1
	if currentLvl < 3:
		self.currModifier= arrStats[self.currentLvl]

func getLevel() -> int:
	return self.currentLvl	
	
func getNextStats() -> void:
	var nextLvl = currentLvl+1
