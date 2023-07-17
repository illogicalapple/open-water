extends Control

## Works with the States autoload to manage the current state of the EscapeMenu.

#@onready var settings_menu := $Settings
@onready var main_select_menu := $"Main Select"
var main_menu_scene : PackedScene = preload("res://scenes/start_menu.tscn")

## Saves mouse mode used before entering escape menu.
## When escape menu exits, will reset mouse mode to this.
var previous_mouse_mode : Input.MouseMode

## Sets to invisible on start.
func _ready() -> void:
	visible = false

## Listens for escape button and exits any sub-menus if pressed.
## Also exits escape menu is not in sub menu.
## If not in escape menu, will enter escape menu.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		match States.game_state:
			States.GameStates.ESCAPE_MENU:
				exit_sub_menu()
			States.GameStates.IN_GAME:
				enter_escape_menu()
	return

func exit_sub_menu() -> void:
	if States.in_escape_menu():
		match States.escape_menu_state:
			States.EscapeMenuStates.CURRENT:
				resume()
			States.EscapeMenuStates.SETTINGS:
				exit_settings_menu()

## Pauses game. This scene's process mode is set to always (so is not affected).
func enter_escape_menu() -> void:
	previous_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().paused = true
	States.game_state = States.GameStates.ESCAPE_MENU
	States.escape_menu_state = States.EscapeMenuStates.CURRENT
	visible = true

## Resumes the game.
func resume() -> void:
	Input.mouse_mode = previous_mouse_mode
	get_tree().paused = false
	States.game_state = States.GameStates.IN_GAME
	States.escape_menu_state = States.EscapeMenuStates.NONE
	visible = false

## Go to main menu scene.
func main_menu() -> void:
	get_tree().paused = false
	States.game_state = States.GameStates.MAIN_MENU
	States.main_menu_state = States.MainMenuStates.CURRENT
	States.escape_menu_state = States.EscapeMenuStates.NONE
	get_tree().change_scene_to_packed(main_menu_scene)
	visible = false

## Ends the game.
func exit_pressed() -> void:
	get_tree().quit()

func enter_settings_menu() -> void:
	Settings.entered()
	
	visible = false
	States.escape_menu_state = States.EscapeMenuStates.SETTINGS
	#States.settings_menu_state = States.SettingsMenuStates.CURRENT

func exit_settings_menu() -> void:
	Settings.exited()
	
	Settings.visible = false
	visible = true
	States.escape_menu_state = States.EscapeMenuStates.CURRENT
	States.settings_menu_state = States.SettingsMenuStates.NONE
