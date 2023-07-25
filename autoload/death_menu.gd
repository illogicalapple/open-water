extends Control

## Kind of the same as escape menu
## not sure if this really needs to be a seperate
## autoload lol.

# Respawn point's global position determines where
# the player will respawn.
@onready var respawn_point : Node3D # This needs to be serialized!!

var main_menu_scene : PackedScene = preload("res://scenes/start_menu.tscn")

func _ready() -> void:
	visible = false

func enter_death_menu() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	States.game_state = States.GameStates.DEATH_MENU
	visible = true

func respawn() -> void:
	visible = false
	#Character.player
	#States.game_state = States.GameStates.IN_GAME
	
	# For now, will just restart the current scene.
	#Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().reload_current_scene()
	

## Go to main menu scene.
func main_menu() -> void:
	get_tree().paused = false
	States.game_state = States.GameStates.MAIN_MENU
	States.main_menu_state = States.MainMenuStates.CURRENT
	get_tree().change_scene_to_packed(main_menu_scene)
	visible = false

## Ends the game.
func exit_pressed() -> void:
	get_tree().quit()
