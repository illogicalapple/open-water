extends ScrollContainer

@onready var fov_slider_label : Label = $VBoxContainer/FOV/Value


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#fov_slider_label.text = 
	pass


func fov_slider_change(value: float) -> void:
	fov_slider_label.text = str(value)
