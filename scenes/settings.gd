extends CanvasLayer

## Works with the States autoload to manage the current state of the SettingsMenu.
## Currentl also saves/loads settings variables. 
## May put loading/saving into another class instead in the future.

@export var video_submenu : VideoSubMenu

#enum VideoSettings {FOV}

func get_value(node : NodePath, property_path : NodePath):
	return get_node(node).get_indexed(property_path.get_as_property_path())

func set_value(node : NodePath, property_path : NodePath, value):
	get_node(node).set_indexed(property_path.get_as_property_path(), value)

# Keys = [node, property path] : value
# Making these the keys will allow for quick and easy
# Setting/Getting for the values.
#var video_settings : Dictionary
#
#var audio_settings : Dictionary
#
#var key_map_settings : Dictionary

## Set on game launch
var default_setting : Dictionary

## Stores all settings from below.
## Is the variant that is serialized into settings.json.
var settings : Dictionary = {
	"video_settings" : {},
	"audio_settings" : {},
	"key_map_settings": {},
}

## Set when settings menu is entered. Cleared when settings menu exits
## Is used to reset values to what it was when settings menu entered.
var reset_setting : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	
	# Create default_settings: empty dictionaries.
	default_setting = {
		"video_settings" : {},
		"audio_settings" : {},
		"key_map_settings": {},
	}
	
	# Load settings.
	load_settings()
	
	# Goes through all settings in video_submenu to set the default.
	for key in video_submenu.key_paths.keys():
		var key_array = video_submenu.key_paths[key]
		
		print ("key array: ", key_array)
		
		var node_path = key_array[0]
		var property_path = key_array[1]
		
		default_setting["video_settings"] [key] = [node_path, property_path, get_value(node_path, property_path)]
	
	# Check to see if settings does NOT have any values in default.
	# If this is the case a new setting has been added and MUST be duplicated into settings.
	# Or error when reseting that value...
	for key in default_setting["video_settings"]:
		if not settings["video_settings"].has(key):
			settings["video_settings"] [key] = default_setting["video_settings"] [key].duplicate(true) #array so should duplicate.
			print_rich("[color=green]New Setting registed: [b]" , key , "[/b][/color]")
	
	set_all_setting_values()
	
# Called when entered from MainMenu and EscapeMenu
func entered() -> void:
	visible = true
	reset_setting = settings.duplicate(true)
	#print ("reset settings: ", reset_setting)

# Called when exited from MainMenu and EscapeMenu
func exited() -> void:
	#print ("exited")
	visible = false
	save_settings()
	reset_setting = {}

func exit_settings_menu() -> void:
	# For now, settings menu can can be either from
	# the main menu or the escape menu.
	if States.in_main_menu():
		# Main Menu is not autoloaded, so will have to GET the main menu from tree
		# and then call the appropriate function on it.
		
		# Getting the Main Menu this way is probably not the best.
		# For instance, we may Rename it in the future. 
		# Alternative: Potentially add Main Menu to a group.
		# And then use tree to get the nodes in that group (will only be 1 node: the main menu).
		# For now, this works though, and making a group with only 1 node in it is feels bad.
		var main_menu := get_tree().get_root().get_node("Main Menu")
		main_menu.exit_settings_menu()
	else:
		# Can call either of these: 
		# Calling exit settings is probably faster
		#EscapeMenu.exit_sub_menu()
		EscapeMenu.exit_settings_menu()

func set_all_setting_values() -> void:
	set_all_video_settings()

func set_all_video_settings() -> void:
	var video_settings = settings["video_settings"]
	
	for key in video_settings.keys():
		var array_val = video_settings[key]
		var node_path = array_val[0]
		var property_path = array_val[1]
		var value = array_val[2]
		
		#print ("array val: ", array_val)
		
		attempt_set_value_or_handle_error(key, node_path, property_path, value)

## Only does video_settings for now.
func default_all_settings() -> void:
	default_all_video_settings()

func reset_all_settings() -> void:
	reset_all_video_settings()

func default_all_video_settings() -> void:
	settings["video_settings"] = default_setting["video_settings"].duplicate(true)
	var default_video_settings = settings["video_settings"]
	
	# Sets all video_setting values to default.
	for key in default_video_settings.keys():
		if not default_video_settings.has(key):
			printerr("attempt to reset setting [", key, "] failed. default_video_settings does not have key.")
			continue
			
		var array_val = default_video_settings [key]
		var node_path = array_val[0]
		var property_path = array_val[1]
		var value = array_val[2]
		
		attempt_set_value_or_handle_error(key, node_path, property_path, value)

func reset_all_video_settings() -> void:
	#Duplicates the reset setting's video_settings.
	settings["video_settings"] = reset_setting["video_settings"].duplicate(true)
	var reset_video_settings = settings["video_settings"]
	
	# Sets all video_setting values to reset values.
	for key in reset_video_settings.keys():
		
		if not reset_video_settings.has(key):
			printerr("attempt to reset setting [", key, "] failed. reset_video_settings does not have key.")
			continue
		
		var array_val = reset_video_settings [key]
		var node_path = array_val[0]
		var property_path = array_val[1]
		var value = array_val[2]

		attempt_set_value_or_handle_error(key, node_path, property_path, value)

func default_single_video_setting(key : String) -> void:
	var video_settings = settings["video_settings"]
	
	if not reset_setting["video_settings"].has(key):
		printerr("attempt to reset setting to default [", key, "] failed. default_setting does not have key.")
		return
	if not video_settings.has(key):
		printerr("attempt to reset setting to default [", key, "] failed. video_settings does not have key.")
		return
	
	var default_array_val = default_setting["video_settings"] [key]
	video_settings[key] = default_array_val.duplicate(true) # Is array so should duplicate.
	
	var node_path = default_array_val[0]
	var property_path = default_array_val[1]
	var value = default_array_val[2]
	
	attempt_set_value_or_handle_error(key, node_path, property_path, value)
	

func reset_single_video_setting(key : String) -> void:
	var video_settings = settings["video_settings"]
	
	if not reset_setting["video_settings"].has(key):
		printerr("attempt to reset setting [", key, "] failed. reset_setting does not have key.")
		return
	if not video_settings.has(key):
		printerr("attempt to reset setting [", key, "] failed. video_settings does not have key.")
		return
	
	var reset_array_value = reset_setting["video_settings"] [key]
	video_settings[key] = reset_array_value.duplicate(true)  # Is array so should duplicate.
	
	var node_path = reset_array_value[0]
	var property_path = reset_array_value[1]
	var value = reset_array_value[2]
	
	attempt_set_value_or_handle_error(key, node_path, property_path, value)

func attempt_set_value_or_handle_error(key : String, node_path : String, property_path : String, value) -> void:
	var node_attempt = get_node_or_null(node_path)
	
	# If can't get node, print error and go to next iteration.
	if node_attempt == null:
		printerr("attempt to set setting [", key, "] failed. Can't get node: ", node_path)
		return
	
	# If can't get property on node, print error and go to next iteration.
	if node_attempt.get_indexed(property_path) == null:
		printerr("attempt to set setting [", key, "] failed. Can't get property: ", property_path)
		return
	
	node_attempt.set_indexed(property_path, value)


#################################################################################

# Using JSON:
# From Documentation: JSON enables all data types to be converted to and from a JSON string.
var json = JSON.new()

var settings_file_path : String = "user://settings.json"

func save_settings() -> void:
	# Open settings file with write access.
	# If file doesn't exist, should create it.
	var settings_file := FileAccess.open(settings_file_path, FileAccess.WRITE)
	
	# Check if there are any errors for opening the file.
	if FileAccess.get_open_error() != Error.OK:
		# Prints error and returns.
		printerr("Unable to save settings: ", FileAccess.get_open_error())
		return
	
	#print ("settings before save: ", settings)
	
	# Convert settings Dictionary into JSON formatted String.
	var settings_json_stringified : String = JSON.stringify(settings, "", false, true)
	
	# Store JSON String to file.
	settings_file.store_string(settings_json_stringified)
	
	print ("saved to: ", settings_file.get_path_absolute())
	
	#print ("saved settings: ", settings)
	
	# Close File.
	#settings_file.close() # Can remove this line. Closes by itself anyway.
	
	
	
	

## Loads file, parses its content through JSON and sets it to settings Dicrionary.
## Prints errors if unable to open or parse.
func load_settings() -> void:
	if FileAccess.file_exists(settings_file_path):
		# Opens existing file
		var settings_file := FileAccess.open(settings_file_path, FileAccess.READ)
		
		print ("loading settings from: ", settings_file.get_path_absolute())
		
		# Check if there are any errors for opening the file.
		if FileAccess.get_open_error() != Error.OK:
			# Prints error and returns.
			printerr("Unable to load settings: ", FileAccess.get_open_error())
			return
		
		# Get JSON String from file.
		# Is saved as JSON String so we know it will be able to be parsed by JSON.
		var settings_json_stringified : String = settings_file.get_as_text()
		
		#print_debug("stringified data: ", settings_json_stringified)
		
		# Close File. Have the data from it now, so don't need it anymore.
		#settings_file.close() # Can remove this line. Closes by itself anyway.
		
		# Convert settings Dictionary into JSON formatted String.
		# parse_string() returns errors only.
		var parsed_settings_result = JSON.parse_string(settings_json_stringified)
		
		#print_debug("parsed data: ", settings_json_stringified)
		
		# Check if there are any errors with parsing the text:
		if parsed_settings_result == null:
			# Prints error and returns.
			printerr("Loaded settings, but unable to parse: ", parsed_settings_result)
			return
		
		# At this point, know we can parse, so can get the data and store it in out variable.
#		var json_data = json.get_data()
#
#		if json_data == null:
#			printerr ("JSON data null... Unable to load settings...")
#			settings = default_setting.duplicate(true)
#		else:
#			settings = json.get_data()
#			print_debug("Settings gotten form JSON data: ", settings)

		settings = parsed_settings_result
		#print ("parsed settings: ", settings)
	else:
		settings = default_setting.duplicate(true)
		
		#print("Settings file not found. This is okay if you haven't saved setttings yet.")







