extends Control

func _unhandled_input(event):
	# commands
	if event.is_action_pressed("commands"):
		$Commands.text = ""
		($Commands as LineEdit).show()
		($Commands as LineEdit).grab_focus()
	if event.is_action_pressed("inventory"):
		States.inventory_state = States.InventoryStates.CURRENT
	if event.is_action_pressed("esc"):
		States.inventory_state = States.InventoryStates.NONE

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

func _process(_delta):
	print(States.in_inventory())
	if States.in_inventory():
		$Inventory/Inventory.visible = true
	else:
		$Inventory/Inventory.visible = false

func _on_commands_focus_exited():
	# cleanup
	$Commands.hide()
