extends Node

enum GameStates {MAIN_MENU, IN_GAME}

enum MainMenuStates {NONE, START, CHOOSE_WORLDS, SETTINGS}

var game_state := GameStates.MAIN_MENU:
	set = game_state_changed

var main_menu_state := MainMenuStates.START:
	set = main_menu_state_changed

func _ready() -> void:
	game_state = GameStates.MAIN_MENU
	main_menu_state = MainMenuStates.START

func game_state_changed(state : GameStates) -> void:
	game_state = state
	Debug.game_state_changed(state)

func main_menu_state_changed(state : MainMenuStates) -> void:
	main_menu_state = state
	Debug.main_menu_state_changed(state)
