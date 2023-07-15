extends CanvasLayer

## Works with the States autoload to manage the current state of the SettingsMenu.
## Currentl also saves/loads settings variables. 
## May put loading/saving into another class instead in the future.

enum VideoSettings {FOV}

# Using JSON:
# From Documentation: JSON enables all data types to be converted to and from a JSON string.
var json = JSON.new()

var settings_file_path : String = "user://settings.json"

var video_settings : Dictionary = {
	VideoSettings.FOV: 75,
}

var audio_settings : Dictionary

var key_map_settings : Dictionary

## Stores all settings from below.
## Is the variant that is serialized into settings.json.
var settings : Dictionary = {
	"vide_settings" : video_settings,
	"audio_settings" : audio_settings,
	"key_map_settings": key_map_settings,
}

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

## Loads file, parses its content through JSON and sets it to settings Dicrionary.
## Prints errors if unable to open or parse.
func load_settings() -> void:
	if FileAccess.file_exists(settings_file_path):
		# Opens existing file
		var settings_file := FileAccess.open(settings_file_path, FileAccess.READ)
		
		# Check if there are any errors for opening the file.
		if settings_file.get_open_error() != Error.OK:
			# Prints error and returns.
			printerr("Unable to load settings: ", settings_file.get_open_error())
			return
		
		# Get JSON String from file.
		# Is saved as JSON String so we know it will be able to be parsed by JSON.
		var settings_json_stringified : String = settings_file.get_as_text()
		
		# Close File. Have the data from it now, so don't need it anymore.
		settings_file.close() # Can remove this line. Closes by itself anyway.
		
		# Convert settings Dictionary into JSON formatted String.
		# parse_string() returns errors only.
		var parsed_settings_result = json.parse_string(settings_json_stringified)
		
		# Check if there are any errors with parsing the text:
		if parsed_settings_result == null:
			# Prints error and returns.
			printerr("Loaded settings, but unable to parse: ", parsed_settings_result)
			return
		
		# At this point, know we can parse, so can get the data and store it in out variable.
		settings = json.get_data()
	else:
		print("Settings file not found. This is okay if you haven't saved setttings yet.")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	load_settings()
	


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
