extends CanvasLayer

@onready var current_game_state_label : Label = $Control/CurrentStates/GameState
@onready var main_menu_state_label : Label = $Control/CurrentStates/MenuState

#func _process(_delta: float) -> void:
#	if Input.is_action_just_pressed("disable_debug"):
#		toggle_debug_menu()

func toggle_debug_menu() -> void:
	if visible:
		hide_debug_menu()
	else:
		show_debug_menu()

func hide_debug_menu() -> void:
	visible = false

func show_debug_menu() -> void:
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("disable_debug"):
		toggle_debug_menu()
