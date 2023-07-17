extends ScrollContainer

# Hides/Shows the correct sub menus.
@export var current_state := States.SettingsMenuStates.CONTROLS

@export var video_submenu : VideoSubMenu
@export var key_map_submenu : ControlsSubMenu

func _ready() -> void:
	match current_state:
		States.SettingsMenuStates.CONTROLS:
			_on_controls_pressed()
		States.SettingsMenuStates.VIDEO:
			_on_video_pressed()
		_:
			# If anything else is selected just go to another menu.
			current_state = States.SettingsMenuStates.CONTROLS
			_on_controls_pressed()

func _on_video_pressed() -> void:
	current_state = States.SettingsMenuStates.VIDEO
	States.settings_menu_state = current_state
	video_submenu.show()
	key_map_submenu.hide()
	

func _on_controls_pressed() -> void:
	current_state = States.SettingsMenuStates.CONTROLS
	States.settings_menu_state = current_state
	key_map_submenu.show()
	video_submenu.hide()
	
#func _on_key_mapping_pressed() -> void:
#	current_state = States.SettingsMenuStates.KEY_MAPPING
#	States.settings_menu_state = current_state
#	key_map_submenu.show()
#	video_submenu.hide()
	

func _on_sounds_pressed() -> void:
	print ("no sound submenu yet.")





