extends CanvasLayer

## Works with the States autoload to manage the current state of the SettingsMenu.

enum VideoSettings {FOV}

## Stores all settings from below.
var settings : Dictionary

var video_settings : Dictionary = {
	VideoSettings.FOV: 75,
}

var audio_settings : Dictionary

var key_map_settings : Dictionary

var settings_file_path : String = "user://settings.cfg"

var config = ConfigFile.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	pass


func save_settings() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	print ("settings")
#
#func _input(event) -> void:
#	print("settigs event")

func exit_settings_menu() -> void:
	# For now, settings menu can can be either from
	# the main menu or the escape menu.
	if States.in_main_menu():
		# Main Menu is not autoloaded, so will have to GET the main menu from tree
		# and then call the appropriate funciton.
		
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

func _on_h_slider_value_changed(value):
	video_settings[VideoSettings.FOV] = value
