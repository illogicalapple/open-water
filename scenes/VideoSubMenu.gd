extends ScrollContainer

@onready var fov_slider_label : Label = $VBoxContainer/FOV/Value
@onready var fov_slider : HSlider = $VBoxContainer/FOV/HSlider

@onready var setting_keys : Array
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setting_keys = [
		[fov_slider.get_path(), "value"],
	]
	fov_slider_label.text = str(fov_slider.value) 

func fov_slider_change(value: float) -> void:
	fov_slider_label.text = str(value)
	Settings.settings["video_settings"] [[fov_slider.get_path(), "value"]] = value

func fov_to_default(_extra_arg_0: NodePath, extra_arg_1: String) -> void:
	# Need to send absolte path. 
	# Ideally signal sends absolute path but can't figure out how.
	Settings.default_single_video_setting(fov_slider.get_path(), extra_arg_1)

func fov_to_reset(_extra_arg_0: NodePath, extra_arg_1: String) -> void:
	Settings.reset_single_video_setting(fov_slider.get_path(), extra_arg_1)


