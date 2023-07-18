extends CanvasLayer

@onready var state_labels : VBoxContainer = $Control/CurrentStates

@onready var current_game_state_label : Label = $Control/CurrentStates/GameState
@onready var main_menu_state_label : Label = $Control/CurrentStates/MenuState
@onready var escape_menu_state_label : Label = $Control/CurrentStates/EscapeState
@onready var settings_menu_state_label : Label = $Control/CurrentStates/SettingsState
@onready var character_state_label : Label = $Control/CurrentStates/CharacterState

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("disable_debug"):
		toggle_debug_menu()


func toggle_debug_menu() -> void:
	if visible:
		visible = false
	else:
		visible = true


# All functions below just update debug labels: ################################

func game_state_changed(state : States.GameStates) -> void:
	current_game_state_label.text = (
		"game_state: " +
		States.GameStates.keys()[state]
	)


func main_menu_state_changed(state : States.MainMenuStates) -> void:
	main_menu_state_label.text = str(
		"main_menu_state: " +
		States.MainMenuStates.keys()[state]
	)
	main_menu_state_label.visible = false if state == States.MainMenuStates.NONE else true


func escape_menu_state_changed(state : States.EscapeMenuStates) -> void:
	escape_menu_state_label.text = str(
		"escape_menu_state: " +
		States.EscapeMenuStates.keys()[state]
	)
	escape_menu_state_label.visible = false if state == States.EscapeMenuStates.NONE else true


func settings_menu_state_changed(state : States.SettingsMenuStates) -> void:
	if is_node_ready(): # Ensures that everything is loaded. 
		settings_menu_state_label.text = str(
			"settings_menu_state: " +
			States.SettingsMenuStates.keys()[state]
		)
		settings_menu_state_label.visible = false if state == States.SettingsMenuStates.NONE else true


func inventory_state_changed(state : States.InventoryStates) -> void:
	if is_node_ready(): # Ensures that everything is loaded. 
		$Control/CurrentStates/InventoryState.text = str(
			"inventory_state: " +
			States.InventoryStates.keys()[state]
		)
		settings_menu_state_label.visible = false if state == States.SettingsMenuStates.NONE else true

func inventory_item_changed(state : int) -> void:
	if is_node_ready(): # Ensures that everything is loaded. 
		$Control/CurrentStates/InventoryItem.text = str(
			"inventory_item: " +
			str(States.inventory_item)
		)
		settings_menu_state_label.visible = false if state == States.SettingsMenuStates.NONE else true

func character_state_changed(state : States.CharacterStates) -> void:
	character_state_label.text = str(
		"character_state: " +
		States.CharacterStates.keys()[state]
	)
	character_state_label.visible = false if state == States.CharacterStates.NORMAL else true


func remake_settings_json() -> void:
	# Delete file if exists: 
	if FileAccess.file_exists(Settings.settings_file_path):
		var file_access = FileAccess.open(Settings.settings_file_path, FileAccess.READ)
		var absolute_path : String = file_access.get_path_absolute()
		file_access.close()
		
		var delete_result : Error = DirAccess.remove_absolute(absolute_path)
		if delete_result != Error.OK:
			printerr("Could not remove file form path: ", absolute_path)
			return
		
		if not FileAccess.file_exists(Settings.settings_file_path):
			print_rich("[color=green]Successfully deleted file at: ", absolute_path, "[/color]")
			#print_rich("[color=green]please restart[/color]")
		else:
			printerr("could not delete file!")
	
	# Dont need to generate defaults again. 
	Settings.load_and_set(false) 
	Settings.save_settings()
