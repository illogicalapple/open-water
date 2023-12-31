extends Node

# this is an autoload, reference using States.game_state, etc.
# for example:

func example_function():
	if States.game_state == States.GameStates.IN_GAME:
		# do some stuff if we're in-game
		pass

# First-level State:
enum GameStates {MAIN_MENU, ESCAPE_MENU, IN_GAME, SETTINGS, DEATH_MENU}
enum CharacterStates {NOCLIP, FLY, SWIM, RUN, NORMAL, DRIVING}

# Second-level States:
enum MainMenuStates {NONE, CURRENT, CHOOSE_WORLDS, SETTINGS}
enum EscapeMenuStates {NONE, CURRENT, SETTINGS}

# Third-level States: 
enum SettingsMenuStates {NONE, CURRENT, VIDEO, AUDIO, CONTROLS} #KEY_MAPPING

#Inventory states
enum InventoryStates {NONE, CURRENT}

# state setters to make things do stuff
var game_state := GameStates.MAIN_MENU:
	set(state):
		game_state = state
		Debug.game_state_changed(state)

var main_menu_state := MainMenuStates.CURRENT:
	set(state):
		main_menu_state = state
		Debug.main_menu_state_changed(state)

var escape_menu_state := EscapeMenuStates.NONE:
	set(state):
		escape_menu_state = state
		Debug.escape_menu_state_changed(state)

var inventory_state := InventoryStates.NONE:
	set(state):
		inventory_state = state
		Debug.inventory_state_changed(state)

var settings_menu_state := SettingsMenuStates.NONE:
	set(state):
		settings_menu_state = state
		#print ("settings state: ", state)
		Debug.settings_menu_state_changed(state)

var character_state := CharacterStates.NORMAL:
	set(state):
		character_state = state
		Debug.character_state_changed(state)

var inventory_item := 0:
	set(state):
		inventory_item = state
		#print ("settings state: ", state)
		Debug.inventory_item_changed(state)


func _ready() -> void:
	game_state = GameStates.MAIN_MENU
	main_menu_state = MainMenuStates.CURRENT
	escape_menu_state = EscapeMenuStates.NONE
	settings_menu_state = SettingsMenuStates.NONE
	character_state = CharacterStates.NORMAL

## Useful for when debugging and loading straight into an in-game scene.
## Should be called on the ready functions of any non-menu scenes.
func set_to_in_game() -> void:
	game_state = GameStates.IN_GAME
	escape_menu_state = EscapeMenuStates.NONE
	main_menu_state = MainMenuStates.NONE
	settings_menu_state = SettingsMenuStates.NONE
	character_state = CharacterStates.NORMAL
	inventory_state = InventoryStates.NONE

## Sets to previous state or prints errors if no previous state is available.
func set_to_previous_menu() -> void:
	# Should check First Level State first, then Second Level, then Third-level, etc.
	
	# Get current menu:
	match game_state:
		GameStates.IN_GAME:
			printerr(
				"set_to_previous_menu(): but there is no previous menu: GameStates: ", 
				state_str(GameStates, GameStates.IN_GAME)
				)
		GameStates.MAIN_MENU:
			match main_menu_state:
				MainMenuStates.CHOOSE_WORLDS:
					pass
				MainMenuStates.SETTINGS:
					pass
				MainMenuStates.NONE:
					printerr("set_to_previous_menu(): GameStates in MAIN_MENU, but MainMenuState is NONE.")
				MainMenuStates.CURRENT:
					printerr(
						"set_to_previous_menu(): but there is no previous menu: MainMenuStates: ",
						state_str(MainMenuStates, MainMenuStates.CURRENT)
						)


## Returns the enum value as String.
## Can be used with any enum type and value due to dynamic paramaters.
func state_str(enum_type, enum_value) -> String:
	return enum_type.keys()[enum_value]


func in_game() -> bool:
	if game_state == GameStates.IN_GAME:
		return true
	else:
		return false


func in_escape_menu() -> bool:
	if game_state == GameStates.ESCAPE_MENU:
		return true
	else:
		return false


func in_main_menu() -> bool:
	if game_state == GameStates.MAIN_MENU:
		return true
	else:
		return false


func in_settings_menu() -> bool:
	if game_state == GameStates.SETTINGS:
		return true
	else:
		return false

func in_inventory() -> bool:
	if inventory_state == InventoryStates.CURRENT:
		return true
	else:
		return false

func in_settings_sub_menu() -> bool:
	if (settings_menu_state == SettingsMenuStates.NONE 
		or settings_menu_state == SettingsMenuStates.CURRENT):
			return false
	else:
		return true


