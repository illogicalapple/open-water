extends SettingsSubMenu
class_name ControlsSubMenu # Giving class name cus want auto-complete.


#@export_group("Labels")
# Using category instead of group because don't want to expand group every time.
@export_category("Property Nodes")
@export var mouse_sensitivity_slider : HSlider

@export_category("Labels") 
@export var mouse_sensitivity_label : Label

@export_group("Default Buttons" , "default_") 
@export var default_mouse_sensitivity : Button

@export_group("Reset Buttons" , "reset_") 
@export var reset_mouse_sensitivity : Button

# Storing save data with 3 values for now.
# 1. Key for its dictionary (e.g., "FOV")
# 2. NodePath (must be absolute)
# 3. PropertyPath.
# This is going to get really long...
@onready var sub_menu_key_paths : Dictionary = {
	"MOUSE_SENSITIVITY": # Unique key
		[mouse_sensitivity_slider.get_path(), # Path to node with the property in it.
		"value" # Property on that node.
		], 
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Settings.visibility_changed.connect(hide_all_reset_buttons)
	Settings.settings_loaded.connect(set_all_buttons_visibility)
	key_paths = sub_menu_key_paths
	key_button_pairs["MOUSE_SENSITIVITY"] = [default_mouse_sensitivity, reset_mouse_sensitivity]
	
	mouse_sensitivity_label.text = str(mouse_sensitivity_slider.value)
	#set_all_buttons_visibility()


# For specific settings:
func mouse_sensitivity_slider_change(value: float) -> void:
	mouse_sensitivity_label.text = str("%.2f" % value) #Formats so always has 2 decimals.

# Getters:
func get_mouse_sensitivity() -> float:
	return mouse_sensitivity_slider.value
