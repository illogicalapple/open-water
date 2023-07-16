extends ScrollContainer

@onready var fov_slider_label : Label = $VBoxContainer/FOV/HBoxVontainer/Value

@export var fov_slider : HSlider

# Storing save data with 3 values for now.
# 1. Key for its dictionary (e.g., "FOV")
# 2. NodePath (must be absolute)
# 3. PropertyPath.
# This is going to get really long...
@onready var setting_keys : Array = [
	["FOV", 
	fov_slider.get_path(),
	"value",
	],
]
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fov_slider_label.text = str(fov_slider.value) 

func fov_slider_change(value: float) -> void:
	fov_slider_label.text = str(value)
	var save_value = [fov_slider.get_path(), "value", value]
	Settings.settings["video_settings"] ["FOV"] = save_value

func set_to_default(key : String) -> void:
	Settings.default_single_video_setting("FOV")

func reset(key : String) -> void:
	Settings.reset_single_video_setting("FOV")


