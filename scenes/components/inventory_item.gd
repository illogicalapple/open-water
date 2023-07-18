extends TextureButton

@export var is_hotbar: bool = false
@export var index: int = 0

var hotbar_texture: CompressedTexture2D = preload("res://assets/images/inventory/hotbar_square.png")
var hotbar_active_texture: CompressedTexture2D = preload("res://assets/images/inventory/selected.png")

func _ready():
	if is_hotbar:
		texture_normal = hotbar_texture

func _process(_delta):
	if get_tree().paused:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
