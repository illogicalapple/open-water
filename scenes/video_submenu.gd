extends SettingsSubMenu
class_name VideoSubMenu # Giving class name cus want auto-complete.


#@export_group("Labels")
# Using category instead of group because don't want to expand group every time.
@export_category("Property Nodes")
@export var fov_slider : HSlider

@export_category("Labels") 
@export var fov_slider_label : Label

@export_group("Default Buttons" , "default_") 
@export var default_FOV : Button

@export_group("Reset Buttons" , "reset_") 
@export var reset_FOV : Button

# Storing save data with 3 values for now.
# 1. Key for its dictionary (e.g., "FOV")
# 2. NodePath (must be absolute)
# 3. PropertyPath.
# This is going to get really long...
@onready var sub_menu_key_paths : Dictionary = {
	"FOV": # Unique key
		[fov_slider.get_path(), # Path to node with the property in it.
		"value" # Property on that node.
		],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Settings.visibility_changed.connect(hide_all_reset_buttons)
	Settings.settings_loaded.connect(set_all_buttons_visibility)
	
	key_paths = sub_menu_key_paths
	key_button_pairs["FOV"] = [default_FOV, reset_FOV]
	
	fov_slider_label.text = str(fov_slider.value)
	#set_all_buttons_visibility()

# For specific settings:
func fov_slider_change(value: float) -> void:
	fov_slider_label.text = str(value)

# Getters:
func get_fov() -> float:
	return fov_slider.value

