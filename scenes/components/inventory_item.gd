extends TextureButton

@export var is_hotbar: bool = false
@export var is_active = false:
	set(active):
		is_active = active
		if active:
			texture_normal = hotbar_active_texture
		else:
			texture_normal = hotbar_texture
@export var index: int = 0

var hotbar_texture: CompressedTexture2D = preload("res://assets/images/inventory/hotbar_square.png")
var hotbar_active_texture: CompressedTexture2D = preload("res://assets/images/inventory/selected.png")
var item: InventoryItem = InventoryItem.new()
var config_file := ConfigFile.new()

func _ready():
	config_file.load("res://behavior/items.cfg")
	if is_hotbar:
		texture_normal = hotbar_texture

func _process(_delta):
	if not Character.inventory[index].type == item.type:
		item.type = Character.inventory[index].type
		$TextureRect.texture = load("assets/images/items/" + item.type + ".png")
	item.amount = Character.inventory[index].amount
	$Amount.text = str(item.amount)
	if item.type == "air":
		$TextureRect.hide()
		$Amount.hide()
		$Tooltip.hide()
	else:
		var color: String = "#ffffff"
		$TextureRect.show()
		$Amount.show()
		match config_file.get_value(item.type, "rarity", 1):
			1:
				color = "#ffffff"
			2:
				color = "#ffc336"
			3:
				color = "#f0abff"
		
		$Tooltip.text = "[color=%s][b]%s[/b][/color]\n[color=#b8b8b8]%s[/color]\n\n%s" % [color, config_file.get_value(item.type, "name", item.type), config_file.get_value(item.type, "type", "useless"), config_file.get_value(item.type, "tooltip", "no description")]
		if get_global_rect().has_point(get_global_mouse_position()):
			$Tooltip.show()
			$Tooltip.global_position = get_global_mouse_position()
		else:
			$Tooltip.hide()


func _on_pressed():
	States.inventory_item = index
	print(States.inventory_item)

