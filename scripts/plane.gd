extends Area2D

@export var x_speed : int = 400
@export_range(0, 1080, 2) var y_offset_radius : int = 400
@export var cooldown : float = 4

@export var _squish_duration : float = 0.5
@export var _squish_scale : float = 0.9

@export var _attack_scene: PackedScene
@export var _attack_cd : float = 10.0
var _attack_cd_timer : Timer

@onready var plane_animated_sprite: AnimatedSprite2D = $PlaneAnimatedSprite
@onready var timer: Timer = $Timer
@onready var plane_audio: AudioStreamPlayer2D = $PlaneAudio

var current_speed : int
var y_starting_position
var flying_left : bool = true
var timer_running : bool = false
var right_border = 2100
var left_border = -200

func _ready():
	connect("area_entered", Callable(self, "_on_area_entered"))
	timer.wait_time = cooldown
	timer.connect("timeout", Callable(self, "_on_cooldown_over"))
	current_speed = x_speed
	y_starting_position = position.y
	plane_animated_sprite.play("default")
	plane_audio.stream = load("res://sfx/PlaneFlying.mp3")
	plane_audio.play()
	
	_attack_cd_timer = Timer.new()
	_attack_cd_timer.wait_time = _attack_cd
	_attack_cd_timer.one_shot = true
	add_child(_attack_cd_timer)

func _process(delta):
	if timer_running:
		return
	if flying_left:
		if position.x < left_border:
			fly()
	else:
		if position.x > right_border:
			fly()
	position.x -= current_speed * delta

func fly():
	current_speed = 0
	#print("Plane Reset Timer Start")
	timer.start()
	timer_running = true
	plane_animated_sprite.flip_h = flying_left
	flying_left = !flying_left

func _on_area_entered(area):
	if area.has_method("pop_bubble"):
		area.pop_bubble()
		# challenge mode check?

func _on_cooldown_over():
	timer.stop()
	timer_running = false
	current_speed = x_speed if flying_left else -x_speed
	@warning_ignore("integer_division")
	var _max = y_offset_radius/2
	var _min = -_max
	position.y = y_starting_position + randi_range(_min,_max)
	plane_audio.play()

func _squish():
	var tween = create_tween()
	tween.tween_property(plane_animated_sprite, "scale", Vector2.ONE, _squish_duration
	).from(Vector2(_squish_scale, _squish_scale)
	).set_ease(Tween.EASE_OUT
	).set_trans(Tween.TRANS_SINE)
	tween.play()

func _attack():
	if not _attack_cd_timer.is_stopped():
		return
	_attack_cd_timer.start()
	var new_attack = _attack_scene.instantiate()
	new_attack.global_position = global_position
	get_parent().add_child(new_attack)
	

func _on_plane_pressed() -> void:
	_attack()
	_squish()
