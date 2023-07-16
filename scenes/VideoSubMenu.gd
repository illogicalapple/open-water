extends ScrollContainer

@export_group("Labels")
@export var fov_slider_label : Label
@export var mouse_sensitivity_label : Label

@export_group("Property Nodes")
@export var fov_slider : HSlider
@export var mouse_sensitivity_slider : HSlider

# Storing save data with 3 values for now.
# 1. Key for its dictionary (e.g., "FOV")
# 2. NodePath (must be absolute)
# 3. PropertyPath.
# This is going to get really long...
#@onready var key_paths : Array = [
#	["FOV", # Unique key
#	fov_slider.get_path(), # Path to node with the property in it.
#	"value", # Property on that node.
#	],
#	["MOUSE_SENSITIVITY", 
#	mouse_sensitivity_slider.get_path(),
#	"value",
#	],
#]
@onready var key_paths : Dictionary = {
	"FOV": # Unique key
		[fov_slider.get_path(), # Path to node with the property in it.
		"value" # Property on that node.
		],
	"MOUSE_SENSITIVITY": [mouse_sensitivity_slider.get_path(), "value"],
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fov_slider_label.text = str(fov_slider.value)
	mouse_sensitivity_label.text = str(mouse_sensitivity_slider.value)

# Saves any settings from any slider:
func slider_change(value: float, key : String) -> void:
	var key_array = key_paths[key]
	var node_path = key_array[0]
	var property_path = key_array[1]
	
	var save_value = [node_path, property_path, value]
	Settings.settings["video_settings"] [key] = save_value

# For any setting:
func set_to_default(key : String) -> void:
	Settings.default_single_video_setting(key)

# For any setting:
func reset(key : String) -> void:
	Settings.reset_single_video_setting(key)


# For specific settings:
func fov_slider_change(value: float) -> void:
	fov_slider_label.text = str(value)

func mosue_sensitivity_slider_change(value: float) -> void:
	mouse_sensitivity_label.text = str(value)

# Getters:
func get_fov() -> float:
	return fov_slider.value
func get_mouse_sensitivity() -> float:
	return mouse_sensitivity_slider.value





