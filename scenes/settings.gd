extends CanvasLayer

## Works with the States autoload to manage the current state of the SettingsMenu.
## Currentl also saves/loads settings variables. 
## May put loading/saving into another class instead in the future.

@onready var video_submenu := $MarginContainer/MarginContainer/VBoxContainer/HBoxContainer/VideoSubMenu

#enum VideoSettings {FOV}

func get_value(node : NodePath, property_path : NodePath):
#	if not is_node_ready():
#		await ready
	return get_node(node).get_indexed(property_path.get_as_property_path())

func set_value(node : NodePath, property_path : NodePath, value):
#	print ("setting: ", get_node(node))
#	print ("property_path: ", property_path.get_as_property_path())
#	print ("setting , ", get_value(node, property_path), " to: ", value)
	
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
	# Create default_settings: empty dictionaries.
	default_setting = {
		"video_settings" : {},
		"audio_settings" : {},
		"key_map_settings": {},
	}
	
	# Goes through all settings in video_submenu to set the default.
	# Adds keys and and sets default values.
	for dict_key in video_submenu.setting_keys:
		default_setting["video_settings"] [dict_key] = get_value(dict_key[0], dict_key[1])
		
	
	
	visible = false
	call_deferred("load_settings")
	
#	print ("Default settings: ", default_setting)
#	print ("Loaded settings: ", settings)

# Called when entered from MainMenu and EscapeMenu
func entered() -> void:
	visible = true
	reset_setting = settings.duplicate(true)

# Called when exited from MainMenu and EscapeMenu
func exited() -> void:
	print ("exited")
	visible = false
	save_settings()
	reset_setting.clear()

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


## Only does video_settings for now.
func default_all_settings() -> void:
	default_all_video_settings()

func reset_all_settings() -> void:
	reset_all_video_settings()

func set_all_setting_values() -> void:
	print_debug ("loading settings is disabled for now... until its fixed")
	#set_all_video_settings()

## Currenlt broken...
## dict_keys is a String instead of an Array...
## JSON is not LOADING teh dictionary values properly...
func set_all_video_settings() -> void:
	var video_settings = settings["video_settings"]
	
	print ("setting values from: ", video_settings)
	
	for dict_keys in video_settings.keys():
		
		print("setting: ", dict_keys)
		
		print ("setting: ", [dict_keys[0], dict_keys[1]])
		
		var node_path = dict_keys[0]
		var property_path = dict_keys[1]
		
		var value = video_settings [dict_keys] 
		set_value(node_path, property_path, value)

func default_all_video_settings() -> void:
	var video_settings = settings["video_settings"]
	print ("setting video to default: ", video_settings)
	# Sets all video_setting values to default.
	for dict_keys in video_settings:
		# Gets default value from default.
		var default_value = default_setting["video_settings"] [dict_keys]
		
		## Debug stuff:
		print ("resetting: ", dict_keys, "\n from: ", video_settings [dict_keys], "\n to: ", default_value)
		
		# Sets default value from default.
		video_settings [dict_keys] = default_value
		
		# Set the property in game:
		var node_path = dict_keys[0]
		var property_path = dict_keys[1]
		
		set_value(node_path, property_path, default_value)

func default_single_video_setting(node_path : NodePath, property_path : String) -> void:
	var video_settings = settings["video_settings"]
	var dict_keys = [node_path, property_path]
	
	print ("default property path: ", property_path)
#	print ("using: ", dict_keys)
#	print ("real: ", default_setting["video_settings"].keys()[0])
	
	
	var default_value = default_setting["video_settings"] [dict_keys]
	
	video_settings [dict_keys] = default_value
	
	set_value(node_path, property_path, default_value)

func reset_all_video_settings() -> void:
	#Duplicates the reset setting's video_settings.
	settings["video_settings"] = reset_setting["video_settings"].duplicate(true)
	
	# Sets all video settings.
	for dict_keys in settings["video_settings"].keys():
		var reset_value = settings["video_settings"] [dict_keys]
		
		var node_path = dict_keys[0]
		var property_path = dict_keys[1]
		
		set_value(node_path, property_path, reset_value)

func reset_single_video_setting(node_path : NodePath, property_path : String) -> void:
	var video_settings = settings["video_settings"]
	var dict_keys = [node_path, property_path]
	
	var reset_value = reset_setting["video_settings"] [dict_keys]
	
	video_settings [dict_keys] = reset_value
	
	set_value(node_path, property_path, reset_value)



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
	if settings_file.get_open_error() != Error.OK:
		# Prints error and returns.
		printerr("Unable to save settings: ", settings_file.get_open_error())
		return
	
	# Convert settings Dictionary into JSON formatted String.
	var settings_json_stringified : String = JSON.stringify(settings)
	
	# Store JSON String to file.
	settings_file.store_string(settings_json_stringified)
	
	# Close File.
	#settings_file.close() # Can remove this line. Closes by itself anyway.
	
	print ("saved to: ", settings_file.get_path_absolute())
	
	#print ("saved settings: ", settings)

## Loads file, parses its content through JSON and sets it to settings Dicrionary.
## Prints errors if unable to open or parse.
func load_settings() -> void:
	if FileAccess.file_exists(settings_file_path):
		# Opens existing file
		var settings_file := FileAccess.open(settings_file_path, FileAccess.READ)
		
		print ("loading settings from: ", settings_file.get_path_absolute())
		
		# Check if there are any errors for opening the file.
		if settings_file.get_open_error() != Error.OK:
			# Prints error and returns.
			printerr("Unable to load settings: ", settings_file.get_open_error())
			return
		
		# Get JSON String from file.
		# Is saved as JSON String so we know it will be able to be parsed by JSON.
		var settings_json_stringified : String = settings_file.get_as_text()
		
		#print_debug("stringified data: ", settings_json_stringified)
		
		# Close File. Have the data from it now, so don't need it anymore.
		#settings_file.close() # Can remove this line. Closes by itself anyway.
		
		# Convert settings Dictionary into JSON formatted String.
		# parse_string() returns errors only.
		var parsed_settings_result = json.parse_string(settings_json_stringified)
		
		#print_debug("parsed data: ", settings_json_stringified)
		
		# Check if there are any errors with parsing the text:
		if parsed_settings_result == null:
			# Prints error and returns.
			printerr("Loaded settings, but unable to parse: ", parsed_settings_result)
			return
		
#		# At this point, know we can parse, so can get the data and store it in out variable.
#		var json_data = json.get_data()
#
#		if json_data == null:
#			printerr ("JSON data null... Unable to load settings...")
#			settings = default_setting.duplicate(true)
#		else:
#			settings = json.get_data()
		settings = parsed_settings_result
		set_all_setting_values()
	else:
		settings = default_setting.duplicate(true)
		
		#print("Settings file not found. This is okay if you haven't saved setttings yet.")







