extends Control

@onready var world_select_menu := $"World Select"
@onready var main_select_menu := $"Main Select"
@onready var settings_menu := $Settings

var main_scene : PackedScene = preload("res://main.tscn")

## Listens for escape button and exits any sub-menus if pressed.
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("esc") and States.in_main_menu():
		exit_sub_menu()


func exit_sub_menu() -> void:
	match States.main_menu_state:
		States.MainMenuStates.CHOOSE_WORLDS:
			exit_world_select()
		States.MainMenuStates.SETTINGS:
			exit_settings_menu()

## Begins the game.
func start_pressed() -> void:
	States.game_state = States.GameStates.IN_GAME
	States.main_menu_state = States.MainMenuStates.NONE
	get_tree().change_scene_to_packed(main_scene)

## Ends the game.
func exit_pressed() -> void:
	get_tree().quit()

func enter_world_select() -> void:
	main_select_menu.visible = false
	world_select_menu.visible = true
	States.main_menu_state = States.MainMenuStates.CHOOSE_WORLDS

func enter_settings_menu() -> void:
	States.main_menu_state = States.MainMenuStates.SETTINGS
	main_select_menu.visible = false
	settings_menu.visible = true

func exit_world_select() -> void:
	States.main_menu_state = States.MainMenuStates.CURRENT
	world_select_menu.visible = false
	main_select_menu.visible = true

func exit_settings_menu() -> void:
	States.main_menu_state = States.MainMenuStates.CURRENT
	settings_menu.visible = false
	main_select_menu.visible = true



