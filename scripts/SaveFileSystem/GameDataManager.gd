extends Node

#class_name GameDataManager

#important to use this as save path, as all other wont work especially on android
#for testing purposes save files under this path will be saved to 
#C:\Users\*CURRUSER*\AppData\Roaming\Godot\app_userdata\OcTeaPop
const save_file_path:= "user://savegame.save"

var score: int = 0
var station_levels: Array[int] = []

# Go through everything in the persist category and ask them to return a
# dict of relevant variables.
func save_game(): #durch alle persistables, classnames and extract relevant data
		
	var save_file = FileAccess.open(save_file_path, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persistables")
	var node_data
	var json_string
	
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		#if node.scene_file_path.is_empty():
		if node.get_path().is_empty():
			print("no path '%s' skipped" % node.name)
			continue
			
		# Check the node has a save function.
		if !node.has_method("save_state"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue

		# Call the node's save function.
		node_data = node.call("save_state")

		# JSON provides a static method to serialized JSON string.
		json_string = JSON.stringify(node_data)

		# Store the save dictionary as a new line in the save file.
		save_file.store_line(json_string)
	
	#exception Tutorial
	node_data = { 
		"type" : "Tutorial",   
		"tutorial_completed": SignalManager.tutorial_completed
		} 
	json_string = JSON.stringify(node_data)
	save_file.store_line(json_string)	
		
# Go through all dictionaries and return relevant variables + save to objects
func load_game():
	if not FileAccess.file_exists(save_file_path):
		return # Error! We don't have a save to load.

	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	var save_file = FileAccess.open(save_file_path, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()

		# Creates the helper class to interact with JSON.
		var json = JSON.new()

		# Check if there is any error while parsing the JSON string, skip in case of failure.
		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
			continue

		# Get the data from the JSON object.
		var node_data = json.data

		#exception tutorial
		if node_data.get("type") == "Tutorial":
			SignalManager.tutorial_completed = node_data["tutorial_completed"]
			continue

		var object_to_load = get_node(node_data["filename"])
		
		# Now we set the remaining variables.
		for i in node_data.keys():
			if object_to_load.has_method("load_state_withDict"):
				object_to_load.call("load_state_withDict", node_data)
			else:
				for key in node_data.keys():
					if key in ["filename", "parent"]:
						continue
					object_to_load.set(key, node_data[key])
		SignalManager.SaveLoad_ShopUpdate.emit()
