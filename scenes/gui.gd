extends Control

var active_child = 1

func _unhandled_input(event):
	# commands
	if event.is_action_pressed("commands"):
		$Commands.text = ""
		($Commands as LineEdit).show()
		($Commands as LineEdit).grab_focus()
	if event.is_action_pressed("inventory") and States.inventory_state == States.InventoryStates.NONE:
		States.inventory_state = States.InventoryStates.CURRENT
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	elif event.is_action_pressed("esc") or Input.is_action_pressed("inventory"):
		# If in inventory, exit the inventory:
		if States.inventory_state == States.InventoryStates.CURRENT:
			States.inventory_state = States.InventoryStates.NONE
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("inv_1"):
		for child in $Inventory/Hotbar.get_children():
			# EXPLOIT THE CHILD
			# CHILD LABOR FTW
			child.is_active = false
		$Inventory/Hotbar/InventoryItem.is_active = true
	if event.is_action_pressed("inv_2"):
		for child in $Inventory/Hotbar.get_children():
			# EXPLOIT THE CHILD
			# CHILD LABOR FTW
			child.is_active = false
		$Inventory/Hotbar/InventoryItem2.is_active = true
	if event.is_action_pressed("inv_3"):
		for child in $Inventory/Hotbar.get_children():
			# EXPLOIT THE CHILD
			# CHILD LABOR FTW
			child.is_active = false
		$Inventory/Hotbar/InventoryItem3.is_active = true
	if event.is_action_pressed("inv_4"):
		for child in $Inventory/Hotbar.get_children():
			# EXPLOIT THE CHILD
			# CHILD LABOR FTW
			child.is_active = false
		$Inventory/Hotbar/InventoryItem4.is_active = true
	if event.is_action_pressed("inv_5"):
		for child in $Inventory/Hotbar.get_children():
			# EXPLOIT THE CHILD
			# CHILD LABOR FTW
			child.is_active = false
		$Inventory/Hotbar/InventoryItem5.is_active = true

func _on_commands_text_submitted(command):
	# when the text is submitted
	$Commands.hide()
	var no_slash: String = command
	if no_slash.begins_with("/"): # remove the slash
		no_slash = no_slash.substr(1)
	var parsed: Array = no_slash.split(" ") # split by spaces
	match parsed[0]: # parse the stuff
		"charstate":
			match parsed[1]:
				"noclip":
					States.character_state = States.CharacterStates.NOCLIP
				"fly":
					States.character_state = States.CharacterStates.FLY
				"normal":
					States.character_state = States.CharacterStates.NORMAL
		"give":
			var item = InventoryItem.new()
			item.type = parsed[1]
			item.amount = parsed[2]
			Character.pick_up(item)

func _process(_delta):
	#print(States.in_inventory())
	if States.in_inventory():
		$Inventory/Inventory.visible = true
	else:
		$Inventory/Inventory.visible = false

func _on_commands_focus_exited():
	# cleanup
	$Commands.hide()
