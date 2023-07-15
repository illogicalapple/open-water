extends Node

enum GameStates {MAIN_MENU, ESCAPE_MENU, IN_GAME}

enum MainMenuStates {NONE, START, CHOOSE_WORLDS, SETTINGS}

enum EscapeMenuStates {NONE, SETTINGS}

var game_state := GameStates.MAIN_MENU:
	set = game_state_changed

var main_menu_state := MainMenuStates.START:
	set = main_menu_state_changed

func _ready() -> void:
	game_state = GameStates.MAIN_MENU
	main_menu_state = MainMenuStates.START
	main_menu_state = MainMenuStates.NONE

func game_state_changed(state : GameStates) -> void:
	game_state = state
	Debug.game_state_changed(state)

func main_menu_state_changed(state : MainMenuStates) -> void:
	main_menu_state = state
	Debug.main_menu_state_changed(state)

func escape_menu_state_changed(state: EscapeMenuStates) -> void:
	Debug.escape_menu_state_changed(state)

