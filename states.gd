extends Node

enum GameStates {MAIN_MENU, ESCAPE_MENU, IN_GAME, SETTINGS}

enum MainMenuStates {NONE, CURRENT, CHOOSE_WORLDS, SETTINGS}
enum EscapeMenuStates {NONE, CURRENT, SETTINGS}
enum SettingsMenuStates {NONE, CURRENT, VIDEO, AUDIO, KEY_MAPPING}

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

var settings_menu_state := SettingsMenuStates.NONE:
	set(state):
		settings_menu_state = state
		Debug.settings_menu_state_changed(state)


func _ready() -> void:
	game_state = GameStates.MAIN_MENU
	main_menu_state = MainMenuStates.CURRENT
	escape_menu_state = EscapeMenuStates.NONE
	settings_menu_state = SettingsMenuStates.NONE

## Useful for when debugging and loading straigth into an in-game scene.
## Should be called on the ready functions of any non-menu scenes.
func set_to_in_game() -> void:
	game_state = GameStates.IN_GAME
	escape_menu_state = EscapeMenuStates.NONE
	main_menu_state = MainMenuStates.NONE
	settings_menu_state = SettingsMenuStates.NONE


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

