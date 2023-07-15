extends CanvasLayer

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func save_settings() -> void:
	
	
	pass
