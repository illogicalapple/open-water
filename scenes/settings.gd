extends CanvasLayer

## Works with the States autoload to manage the current state of the SettingsMenu.
## Currentlt also saves/loads settings variables. 
## May put loading/saving into another class instead in the future.

signal settings_loaded

@export var default_button : Button
@export var reset_button : Button

@export var submenu_selector : Node

@export var video_submenu : VideoSubMenu
#@export var keymap_submenu : KeyMapSubMenu
@export var controls_submenu : ControlsSubMenu

# Holds REFERENCES/POINTERS to dictionaries. Not copies. 
@onready var submenu_default_property_changes : Array[Dictionary] = [
	video_submenu.default_property_changes,
	controls_submenu.default_property_changes,
]
# Holds REFERENCES/POINTERS to dictionaries. Not copies. 
@onready var submenu_reset_property_changes : Array[Dictionary] = [
	video_submenu.revert_property_changes,
	controls_submenu.revert_property_changes,
]

# Later: change function so doesn't need to repeat code for default and reset
func set_default_and_reset_button_visibility() -> void:
	var submenu_default_property_changes : Array[Dictionary] = [
		video_submenu.default_property_changes,
		controls_submenu.default_property_changes,
	]
	# Holds REFERENCES/POINTERS to dictionaries. Not copies. 
	var submenu_reset_property_changes : Array[Dictionary] = [
		video_submenu.revert_property_changes,
		controls_submenu.revert_property_changes,
	]
	
	# Checks for default
	# If all default_property_changes dictionaries in submenus are empty.
	# Set to invisible. Else visible.
	
	# Check if any dictionary is NOT empty:
	if (
		submenu_default_property_changes.any(
		func (dict : Dictionary):
			if not dict.is_empty():
				#print ("not empty dict: ", dict) 
				return true
			else:
				#print ("all defaults are empty")
				return false
	)):
		# something is not empty. Keep global default button visible.
		default_button.visible = true
	else:
		#print ("all defaults are empty?")
		default_button.visible = false
	
	# Checks for reset
	# If all revert_property_changes dictionaries in submenus are empty.
	# Set to invisible. Else visible. 
	
	# Check if any dictionary is NOT empty:
	if (
		submenu_reset_property_changes.any(
		func (dict : Dictionary) : 
			if not dict.is_empty():
				return true
			else:
				return false
	)):
		# something is not empty. Keep global reset button visible.
		reset_button.visible = true
	else:
		reset_button.visible = false





#enum VideoSettings {FOV}

func get_value(node : NodePath, property_path : NodePath):
	return get_node(node).get_indexed(property_path.get_as_property_path())

func set_value(node : NodePath, property_path : NodePath, value):
	get_node(node).set_indexed(property_path.get_as_property_path(), value)

## Set on game launch
var default_setting : Dictionary

## Stores all settings from below.
## Is the variant that is serialized into settings.json.
@onready var settings : Dictionary = {
	"video_settings" : {
		"default_property_changes": video_submenu.default_property_changes
	},
	"audio_settings" : {},
	"controls_settings": {
		"default_property_changes": controls_submenu.default_property_changes
	},
}

## Set when settings menu is entered. Cleared when settings menu exits
## Is used to reset values to what it was when settings menu entered.
var reset_setting : Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	reset_button.visible = false
	
	load_and_set()


func load_and_set(regenerate_default : bool = true) -> void:
	# Create default_settings: empty dictionaries.
	if regenerate_default:
		default_setting = settings.duplicate(true)
	
	# Load settings.
	load_settings()
	
	
	# Goes through all settings in sub_menus to set the default.
	if regenerate_default:
		for setting_key in default_setting.keys():
			set_default_settings_from_submenu(setting_key)
	
	#print ("default settings: ", default_setting)
	
	for setting_key in default_setting.keys():
		check_for_new_default_values(setting_key)
	
	set_all_setting_values()
	#print ("loaded settings: ", default_setting)
	settings_loaded.emit()

# Check to see if settings does NOT have any values in default.
# If this is the case a new setting has been added and MUST be duplicated into settings.
# If we dont do this, will get an error when reseting that value...
func check_for_new_default_values(settings_key : String) -> void:
	if not default_setting.has(settings_key):
		printerr("default value does not have new setting: ", settings_key, "consider deleting settings.JSON and regenerating.")
		return
	
	if not settings.has(settings_key):
		print_rich("[color=green]New Settings key: [b]" , settings_key , "[/b][/color]")
		settings[settings_key] = default_setting[settings_key].duplicate(true)
	
	for key in default_setting[settings_key]:
		if not settings[settings_key].has(key):
			settings[settings_key] [key] = default_setting[settings_key] [key].duplicate(true) #array so should duplicate.
			print_rich("[color=green]New Setting registed: [b]" , key , "[/b][/color]")

func set_default_settings_from_submenu(settings_key : String) -> void:
	var submenu = get_submenu_from_settings_key_or_null(settings_key)
	
	# get_submenu_from_key_or_null already prints out errors, so can just return.
	if submenu == null:
		return

	for key in submenu.key_paths.keys():
		var key_array = submenu.key_paths[key]
		
		#print ("key array: ", key_array)
		
		var node_path = key_array[0]
		var property_path = key_array[1]
		
		default_setting[settings_key] [key] = [node_path, property_path, get_value(node_path, property_path)]

func get_submenu_from_settings_key_or_null(settings_key : String):
	match settings_key:
		"video_settings":
			return video_submenu
		"controls_settings":
			return controls_submenu
		"audio_settings":
			return null
		_:
			printerr("attempt to load default settings from unknown submenu: ", settings_key)
			return null

func get_setting_key_from_submenu_or_null(submenu : Node):
	# Ideally should use a match statement for this
	# but get_class() CAN'T return class_names...
	# Cannot override get_class() method, just ignores the override.
	# So using if statements instead :(
	
#	match submenu.get_class():
#		"VideoSubMenu":
#			return "video_settings"
#		"ControlsSubMenu":
#			return "controls_settings"
#		_:
#			printerr("attempt to get settings_key from unknown submenu type: ", submenu, "'s type is: " , submenu.get_class())
#			return null
	
	if submenu is VideoSubMenu:
		return "video_settings"
	elif submenu is ControlsSubMenu:
		return "controls_settings"
	else:
		printerr("attempt to get settings_key from unknown submenu type: ", submenu, "'s type is: " , submenu.get_class())
		return null



# Called when entered from MainMenu and EscapeMenu
func entered() -> void:
	visible = true
	#print ("settings: ", settings)
	reset_setting = settings.duplicate(true)
	#print ("\nreset settings: ", reset_setting)
	States.settings_menu_state = submenu_selector.current_state
	
	submenu_selector.pick_current_state()

# Called when exited from MainMenu and EscapeMenu
func exited() -> void:
	#print ("exited")
	visible = false
	save_settings()
	
	# Clear all reset settings:
	reset_setting.clear()
	reset_button.visible = false
	for dict in submenu_reset_property_changes:
		dict.clear()
	

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
	for setting_key in settings.keys():
		var specific_settings = settings[setting_key] # iterates over "video_settings" and "controls_settings", etc.
		
		for key in specific_settings.keys(): # e.g., all keys in settings["video_settings"]
			if key == "default_property_changes": continue
			var array_val = specific_settings[key]
			var node_path = array_val[0]
			var property_path = array_val[1]
			var value = array_val[2]
			
			attempt_set_value_or_handle_error(key, node_path, property_path, value)
	

## Only does video_settings for now.
func default_all_settings() -> void:
	for setting_key in settings.keys(): # iterates over "video_settings" and "controls_settings", etc.
		
		if not default_setting.has(setting_key):
			printerr("default_setting does not have key: ", setting_key ,". Please regenerate settings.JSON")
			continue
			
		default_specific_setting(setting_key)

func default_specific_setting(setting_key : String) -> void:
	settings[setting_key] = default_setting[setting_key].duplicate(true)
	var default_specific_settings = settings[setting_key] # e.g., default version of "video_settings"

	# Sets all values to default.
	for key in default_specific_settings.keys():
		if key == "default_property_changes": continue
		if not default_specific_settings.has(key):
			printerr("attempt to reset setting [", key, "] failed. default settings of", setting_key , " does not have key.")
			continue
			
		var array_val = default_specific_settings [key]
		var node_path = array_val[0]
		var property_path = array_val[1]
		var value = array_val[2]
		
		attempt_set_value_or_handle_error(key, node_path, property_path, value)


func reset_all_settings() -> void:
	for setting_key in settings.keys(): # iterates over "video_settings" and "controls_settings", etc.
		
		if not reset_setting.has(setting_key):
			printerr("reset_setting does not have key: ", setting_key ,". Please regenerate settings.JSON")
			continue
		
		reset_specific_setting(setting_key)


func reset_specific_setting(setting_key : String) -> void:
	settings[setting_key] = reset_setting[setting_key].duplicate(true)
	var reset_specific_settings = settings[setting_key] # e.g., default version of "video_settings"
	
	#print ("resetting to: ", reset_specific_settings)
	
	# Sets all values to reset values.
	for key in reset_specific_settings.keys():
		if key == "default_property_changes": continue
		if not reset_specific_settings.has(key):
			printerr("attempt to reset setting [", key, "] failed. reset settings of", setting_key , " does not have key.")
			continue
		
		var array_val = reset_specific_settings [key]
		var node_path = array_val[0]
		var property_path = array_val[1]
		var value = array_val[2]

		attempt_set_value_or_handle_error(key, node_path, property_path, value)



func default_single_setting(key : String, submenu: Node) -> void:
	var setting_key = get_setting_key_from_submenu_or_null(submenu) 
	
	# get_setting_key_from_submenu_or_null prints errors. can just return.
	if setting_key == null:
		return
	
	if not default_setting[setting_key].has(key):
		printerr("attempt to reset setting [", key, "] failed. default_setting does not have key.")
		return
	
	if not settings.has(setting_key):
		printerr ("attempt to reset setting [", key, "] failed. Specific setting [", setting_key, "] does not exist")
	
	var specific_settings = settings[setting_key] 
	
	if not specific_settings.has(key):
		printerr("attempt to reset setting [", key, "] failed. ", setting_key ," does not have key.")
		return
	
	var default_array_val = default_setting[setting_key] [key]
	specific_settings[key] = default_array_val.duplicate(true) # Is array so should duplicate.
	
	var node_path = default_array_val[0]
	var property_path = default_array_val[1]
	var value = default_array_val[2]
	
	attempt_set_value_or_handle_error(key, node_path, property_path, value)


func reset_single_setting(key : String, submenu: Node) -> void:
	var setting_key = get_setting_key_from_submenu_or_null(submenu) 
	
	# get_setting_key_from_submenu_or_null prints errors. can just return.
	if setting_key == null:
		return
	
	if not reset_setting[setting_key].has(key):
		printerr("attempt to reset setting [", key, "] failed. reset_setting does not have key.")
		return
	
	if not settings.has(setting_key):
		printerr ("attempt to reset setting [", key, "] failed. Specific setting [", setting_key, "] does not exist")
	
	var specific_settings = settings[setting_key] 
	
	if not specific_settings.has(key):
		printerr("attempt to reset setting [", key, "] failed. ", setting_key ," does not have key.")
		return
	
	var reset_array_value = reset_setting[setting_key] [key]
	specific_settings[key] = reset_array_value.duplicate(true)  # Is array so should duplicate.
	
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
		
		print_rich ("[color=green]loading settings from: ", settings_file.get_path_absolute(),"[/color]")
		
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
		
		#settings_loaded.emit()
		
		# load all default_property_changes in each submenu
		for setting_key in settings.keys():
			var submenu = get_submenu_from_settings_key_or_null(setting_key)
			
			if not settings[setting_key].has("default_property_changes"):
				# temporarily commenting out!
				#printerr(setting_key , ": does not have default_property_changes! Please regenerate settings.JSON")
				return
			
			submenu.default_property_changes = settings[setting_key]["default_property_changes"]
		
		
		#print ("parsed settings: ", settings)
	else:
		settings = default_setting.duplicate(true)
		
		#print("Settings file not found. This is okay if you haven't saved setttings yet.")







