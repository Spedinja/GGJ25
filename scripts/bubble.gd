extends Area2D

var frequency : float = 5
var amplitude : float = 150
var upwards_speed : float = 100
var direction = 1 # Determines the horizontal direction (1 for right, -1 for left)

var time = 0

var bubbleScale: float = 1
var delete_timer = 0

#Signal
signal bubble_popped(param)
var is_clicked = false
var bubbleValue

func _ready() -> void:
	bubbleScale= randf_range(1,4)
	setBubbleScale(bubbleScale)
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
			emit_signal("bubble_popped")
			queue_free()  # Removes the bubble when clicked (pops it)
			#get_tree().root.get_node("MainScene").add_score(10)  # Add points to the score

func setBubbleScale(givenScale) -> void:
	bubbleScale = givenScale
	scale.x = bubbleScale
	scale.y = bubbleScale

#func setBubbleValue(givenValue) -> void:
#	self.bubbleValue = givenValue

func getBubbleValue() -> int:
	return self.bubbleValue

func adjustBubbleValues(multiplier) -> void:
	frequency = 5 + multiplier
	amplitude = 150 + (multiplier * 4)
	upwards_speed = 100 + (multiplier * 10)
	bubbleValue = bubbleScale * multiplier
	
