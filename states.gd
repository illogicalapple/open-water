extends Node

enum GameStates {MAIN_MENU, ESCAPE_MENU, IN_GAME}

enum MainMenuStates {NONE, CURRENT, CHOOSE_WORLDS, SETTINGS}

enum EscapeMenuStates {NONE, CURRENT, SETTINGS}

var game_state := GameStates.MAIN_MENU:
	set = game_state_changed

var main_menu_state := MainMenuStates.CURRENT:
	set = main_menu_state_changed

var escape_menu_state := EscapeMenuStates.NONE:
	set = escape_menu_state_changed

func _ready() -> void:
	game_state = GameStates.MAIN_MENU
	main_menu_state = MainMenuStates.CURRENT
	escape_menu_state = EscapeMenuStates.NONE

func game_state_changed(state : GameStates) -> void:
	game_state = state
	Debug.game_state_changed(state)

func main_menu_state_changed(state : MainMenuStates) -> void:
	main_menu_state = state
	Debug.main_menu_state_changed(state)

func escape_menu_state_changed(state: EscapeMenuStates) -> void:
	escape_menu_state = state
	Debug.escape_menu_state_changed(state)

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


