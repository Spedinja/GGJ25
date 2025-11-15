extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var down_time: Timer = $DownTime
@export var down_time_duration : float = 2.0
@export var animation_speed : float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalManager.move_to_bubbles.connect(on_first_move)
	animation_player.play("Tutorial2")
	animation_player.speed_scale = animation_speed
	down_time.wait_time = down_time_duration
	down_time.timeout.connect(_on_downtime_over)

func _on_animation_player_animation_finished(_anim_name: StringName):
	down_time.start()

func _on_downtime_over():
	animation_player.play("Tutorial2")

func on_first_move():
	SignalManager.tutorial_completed = true
	queue_free()
