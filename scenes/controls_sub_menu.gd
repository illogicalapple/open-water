extends ScrollContainer
class_name ControlsSubMenu # Giving class name cus want auto-complete.

#@export_group("Labels")
# Using category instead of group because don't want to expand group every time.
@export_category("Labels") 
@export var mouse_sensitivity_label : Label

@export_category("Property Nodes")
@export var mouse_sensitivity_slider : HSlider

# Storing save data with 3 values for now.
# 1. Key for its dictionary (e.g., "FOV")
# 2. NodePath (must be absolute)
# 3. PropertyPath.
# This is going to get really long...
@onready var key_paths : Dictionary = {
	"MOUSE_SENSITIVITY": # Unique key
		[mouse_sensitivity_slider.get_path(), # Path to node with the property in it.
		"value" # Property on that node.
		], 
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_sensitivity_label.text = str("%0.2f" % mouse_sensitivity_slider.value)

#@warning_ignore("native_method_override")
#func get_class():
#	return "ControlsSubMenu"
#
#@warning_ignore("native_method_override")
#func is_class(value):
#	return value == "ControlsSubMenu"

# Saves any settings from any slider:
func slider_change(value: float, key : String) -> void:
	var key_array = key_paths[key]
	var node_path = key_array[0]
	var property_path = key_array[1]
	
	var save_value = [node_path, property_path, value]
	
	var settings_key = Settings.get_setting_key_from_submenu_or_null(self) # Will be "video_settings" or "key_map_setting", etc.
	if settings_key == null:
		printerr("cannot save setting")
		return
	Settings.settings[settings_key] [key] = save_value

# For any setting:
func set_to_default(key : String) -> void:
	Settings.default_single_setting(key, self)

# For any setting:
func reset(key : String) -> void:
	Settings.reset_single_setting(key, self)

# For specific settings:
func mouse_sensitivity_slider_change(value: float) -> void:
	mouse_sensitivity_label.text = str("%.2f" % value) #Formats so always has 2 decimals.

# Getters:
func get_mouse_sensitivity() -> float:
	return mouse_sensitivity_slider.value



#func _on_visibility_changed() -> void:
#	# May be entering or exiting... [may be hidden or visible]
#	# Entering if not currently set to the corresponding state
#	if States != null: # Will be null when game starts up. Node is not ready()
#		if States.settings_menu_state != States.SettingsMenuStates.KEY_MAPPING:
#			# Entering
#			#print ("entering")
#			States.settings_menu_state = States.SettingsMenuStates.KEY_MAPPING
#		else:
#			# Exiting.
#			#print ("exiting")
#			States.settings_menu_state = States.SettingsMenuStates.CURRENT
#
