extends ScrollContainer

@onready var fov_slider_label : Label = $VBoxContainer/FOV/Value
@onready var fov_slider : HSlider = $VBoxContainer/FOV/HSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fov_slider_label.text = str(fov_slider.value) 

# Dictionary = passed by reference, not a copy.
# Changing this also changes the video_settings value in Settings class.
@onready var video_settings : Dictionary = Settings.video_settings

func fov_slider_change(value: float) -> void:
	fov_slider_label.text = str(value)
	video_settings[Settings.VideoSettings.FOV] = value
