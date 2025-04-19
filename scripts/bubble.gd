extends Area2D

@export var bubble_data: Bubble
var direction = 1 # Determines the horizontal direction (1 for right, -1 for left)

var time = 0

var bubbleScale: float = 1
var delete_timer = 0

#Signal
#signal bubble_popped(param)
var is_clicked = false

func _ready() -> void:
	self.bubbleScale= randf_range(2,4)
	self.setBubbleScale(bubbleScale)
	self.direction = randf_range(-1,1)

func _physics_process(delta):
	self.time += delta
	self.delete_timer = self.time
	var wiggle = sin(time*bubble_data.frequency)*bubble_data.amplitude*direction
	self.position.x += wiggle * delta
	self.position.y -= bubble_data.upwards_speed * delta
	
	if delete_timer > (0.05 * bubble_data.upwards_speed): #change to speed/value
		queue_free()

# Called when the mouse clicks on the bubble.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if not is_clicked:
			pop_bubble()
			

func pop_bubble():
	is_clicked = true
	#emit_signal("bubble_popped")
	SignalManager.bubble_popped.emit(self.getBubbleValue())
	SignalManager.bubble_popped.emit()
	queue_free()  # Removes the bubble when clicked (pops it)
	#get_tree().root.get_node("MainScene").add_score(10)  # Add points to the score

func setBubbleScale(givenScale) -> void:
	bubbleScale = givenScale
	self.scale.x = bubbleScale
	self.scale.y = bubbleScale

func setBubbleValue(value) -> void:
	self.bubble_data.bubbleValue = value

func getBubbleValue() -> int:
	return self.bubble_data.bubbleValue

func adjustBubbleValues(multiplier) -> void:
	var random_multiplier: float = randf_range(-1,1)
	self.bubble_data.frequency = self.bubble_data.frequency + random_multiplier #+- multiplier
	self.bubble_data.amplitude = self.bubble_data.amplitude + (random_multiplier*10) #+- (multiplier * 10)
	self.bubble_data.upwards_speed = self.bubble_data.upwards_speed + (random_multiplier*10) #+- (multiplier * 10)
	#self.bubble_data = self.bubble_data.bubbleValue * multiplier  #bubbleScale * multiplier
