extends Area2D

@export var frequency : float = 5
@export var amplitude : float = 150
@export var upwards_speed : float = 100

var time = 0

var is_clicked = false

func _physics_process(delta):
	time += delta
	var wiggle = sin(time*frequency)*amplitude
	position.x += wiggle * delta
	position.y -= upwards_speed * delta

# Called when the mouse clicks on the bubble.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_clicked:
			is_clicked = true
			queue_free()  # Removes the bubble when clicked (pops it)
			#get_tree().root.get_node("MainScene").add_score(10)  # Add points to the score
