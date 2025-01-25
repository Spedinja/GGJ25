extends Area2D

@export var frequency : float = 5
@export var amplitude : float = 150
@export var upwards_speed : float = 100
var direction = 1 # Determines the horizontal direction (1 for right, -1 for left)

var time = 0

var bubbleScale: float
var delete_timer = 0

var is_clicked = false

func _ready() -> void:
	direction = randf_range(-1,1)

func _physics_process(delta):
	time += delta
	delete_timer = time
	var wiggle = sin(time*frequency)*amplitude*direction
	position.x += wiggle * delta
	position.y -= upwards_speed * delta
	
	if delete_timer > (0.05 * upwards_speed): #change to speed/value
		queue_free()

# Called when the mouse clicks on the bubble.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_clicked:
			is_clicked = true
			queue_free()  # Removes the bubble when clicked (pops it)
			#get_tree().root.get_node("MainScene").add_score(10)  # Add points to the score

func setBubbleScale(givenScale) -> void:
	bubbleScale = givenScale
	scale.x = bubbleScale
	scale.y = bubbleScale
