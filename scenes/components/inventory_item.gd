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

func _ready():
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
	else:
		$TextureRect.show()
		$Amount.show()


func _on_pressed():
	States.inventory_item = index
	print(States.inventory_item)
