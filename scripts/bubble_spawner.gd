extends Node2D

#vars
var accum_time = 0

# ressource gies here
@export var spawner_data: Spawner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawner_data.isUnlocked == true:
		self.accum_time += delta
		if self.accum_time>1:
			self.spawn_bubble()
			self.accum_time = 0

func spawn_bubble():
	if spawner_data and spawner_data.bubble_scene:
		var bubble_instance = spawner_data.bubble_scene.instantiate()
		if self.spawner_data.toUpdate:
			bubble_instance.setBubbleValue(self.spawner_data.currModifier)
			bubble_instance.adjustBubbleValues(self.spawner_data.currentLvl)
			#bubble_instance.adjustBubbleValues(self.spawner_data.currModifier)
			self.spawner_data.toUpdate = false
		bubble_instance.position = position
		#SignalManager.bubble_popped.disconnect($"../../..".on_bubble_popped.bind(bubble_instance.getBubbleValue()))
		#SignalManager.bubble_popped.connect($"../../..".on_bubble_popped.bind(bubble_instance.getBubbleValue()))
		#bubble_instance.bubble_popped.connect($"../../..".on_bubble_popped.bind(bubble_instance.getBubbleValue()))
		$"../../Bubbles".add_child(bubble_instance)
	else:
			print("error no bubble")

func _unlockSpawner() -> void:
	self.spawner_data.isUnlocked = true


func levelUp() -> int:
	if spawner_data.currentLvl+1 == 0:
		SignalManager.machine_unlocked.emit()
	else:
		SignalManager.machine_level_up.emit()
	self._increaseStats()
	if self.spawner_data.currentLvl == 0:#vorher1
		self._unlockSpawner()
	GameDataManager.save_game() # save each upgrade
	return self.spawner_data.currentLvl
	
func _increaseStats()-> void:
	#get next element from array, adjust on instantiate
	spawner_data.currentLvl = spawner_data.currentLvl+1
	if spawner_data.currentLvl < 3:
		self.spawner_data.currModifier= spawner_data.arrStats[spawner_data.currentLvl]
		self.spawner_data.toUpdate = true


func getLevel() -> int:
	return self.spawner_data.currentLvl	
	
func getNextStats() -> void:
	var nextLvl = self.spawner_data.currentLvl+1

func save_state() -> Dictionary:
	var save_dict = { 
		"filename" : self.get_path(), 
		"parent" : get_parent().get_path(), 
		"spawner_Lvl" : self.spawner_data.currentLvl, 
		"currModifier" : self.spawner_data.currModifier, 
		"isUnlocked": self.spawner_data.isUnlocked
		} 
	return save_dict

func load_state_withDict(data: Dictionary) -> void:
	spawner_data.currentLvl = data.get("spawner_Lvl", -1)
	spawner_data.isUnlocked = data.get("isUnlocked", false)
	if spawner_data.currentLvl >= 0:
		spawner_data.currModifier = spawner_data.currModifier
		spawner_data.toUpdate = true
