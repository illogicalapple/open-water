extends Node
var player=null
###################################################
# INVENTORY:
func air() -> InventoryItem:
	return InventoryItem.new()

var inventory: Array = [
	air(), air(), air(), air(), air(), # HOTBAR
	
	air(), air(), air(), air(), air(), # INVENTORY
	air(), air(), air(), air(), air(), # |
	air(), air(), air(), air(), air(), # |
	air(), air(), air(), air(), air(), # V
]

func pick_up(item) -> bool:
	for inv_item in inventory:
		if inv_item.type == item.type:
			inv_item.amount += item.amount
			return true # exits if it finds a stackable slot
	
	for inv_item in inventory:
		if inv_item.type == "air":
			inv_item.type = item.type
			inv_item.amount = item.amount
			return true # exits if it finds an empty slot
	
	return false # oops, you failed your search smh
	
# END OF INVENTORY
###################################################
