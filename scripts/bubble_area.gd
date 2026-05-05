extends Node2D

@onready var current_money_us: Label = $"../HUD/Score/CurrentMoney_US"
@onready var current_money_ls: Label = $"../ShopArea/ShopArea_UI/CurrentMoney_LS"


@onready var score: int = 10
#@onready var bubble_scene = preload("res://scenes/bubble.tscn")
#@onready var timer
var accum_time = 0
var score_chg_counter: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	#$SpawnArea/BubbleSpawn/BubbleSpawn_1.levelUp(1)
	current_money_us.text = str("$: ", score)
	current_money_ls.text = str("$: ", score)
	SignalManager.money_changed.connect(on_money_changed)
	SignalManager.bubble_popped.connect(on_bubble_popped)
	
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

func change_score(points):
	if points > 0:
		score += points
	else:
		score+= points
	current_money_us.text = str("$: ", score)
	current_money_ls.text = str("$: ", score)
	
	#after 20 changes save
	if score_chg_counter == 20:
		GameDataManager.save_game()
		score_chg_counter = 1
	else:
		score_chg_counter+=1
	
func on_bubble_popped(arg1):
	SignalManager.money_changed.emit(arg1)
	
func on_money_changed(arg1):
	change_score(arg1)

func getCash() -> int:
	return score

func save_state():
	var save_dict = {
		"filename" : self.get_path(),
		"parent" : get_parent().get_path(),
		"score" : score
	}
	return save_dict

func load_state_withDict(data: Dictionary):
	score = int(data.get("score", 0))
	current_money_us.text = str("$: ", score)
	current_money_ls.text = str("$: ", score)
