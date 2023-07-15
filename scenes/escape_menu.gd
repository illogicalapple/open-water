extends Control

@onready var settings_menu := $Settings
@onready var main_select_menu := $"Main Select"
var main_menu_scene : PackedScene = preload("res://scenes/start_menu.tscn")

## Sets to invisible on start.
func _ready() -> void:
	visible = false

## Listens for escape button and exits any sub-menus if pressed.
## Also exits escape menu is not in sub menu.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc"):
		print ("escape pressed")
		match States.game_state:
			States.GameStates.ESCAPE_MENU:
				exit_sub_menu()
			States.GameStates.IN_GAME:
				enter_escape_menu()

func exit_sub_menu() -> void:
	match States.escape_menu_state:
		States.EscapeMenuStates.CURRENT:
			resume()
		States.EscapeMenuStates.SETTINGS:
			exit_settings_menu()

## Pauses game. This scene's process mode is set to always (so is not affected).
func enter_escape_menu() -> void:
	print ("enter escape")
	get_tree().paused = true
	States.game_state = States.GameStates.ESCAPE_MENU
	States.escape_menu_state = States.EscapeMenuStates.CURRENT
	visible = true

## Resumes the game.
func resume() -> void:
	print ("exit escape menu")
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
	settings_menu.visible = true
	main_select_menu.visible = false
	States.escape_menu_state = States.EscapeMenuStates.SETTINGS

func exit_settings_menu() -> void:
	settings_menu.visible = false
	main_select_menu.visible = true
	States.escape_menu_state = States.EscapeMenuStates.CURRENT
