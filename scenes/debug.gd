extends CanvasLayer

@onready var state_labels : VBoxContainer = $Control/CurrentStates

@onready var current_game_state_label : Label = $Control/CurrentStates/GameState
@onready var main_menu_state_label : Label = $Control/CurrentStates/MenuState
@onready var escape_menu_state_label : Label = $Control/CurrentStates/EscapeState
@onready var settings_menu_state_label : Label = $Control/CurrentStates/SettingsState

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("disable_debug"):
		toggle_debug_menu()

func toggle_debug_menu() -> void:
	if visible:
		visible = false
	else:
		visible = true

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
	escape_menu_state_label.text = str(
		"settings_menu_state: " +
		States.SettingsMenuStates.keys()[state]
	)
	settings_menu_state_label.visible = false if state == States.SettingsMenuStates.NONE else true


