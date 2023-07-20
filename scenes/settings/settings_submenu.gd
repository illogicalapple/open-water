extends Control
class_name SettingsSubMenu

## Should be a class that SubMenu classes EXTEND.

var default_property_changes : Dictionary = {}
var revert_property_changes : Dictionary = {}

#@export_group("Labels") # Using category instead of group because don't want to expand group every time.

@export_group("Default Buttons") 
@export var default_submenu_button : Button

@export_group("Reset Buttons") 
@export var reset_submenu_button : Button

# Storing save data with 3 values for now.
# 1. Key for its dictionary (e.g., "FOV")
# 2. NodePath (must be absolute)
# 3. PropertyPath.
var key_paths : Dictionary = {} # Is set to sub_menu_key_paths from inside submenu nodes.

var key_button_pairs : Dictionary = {} # "FOV: [default_button, reset_button]"


# Putting things in the ready function here does nothing for the node that extends this class.
func _ready() -> void:
	#Settings.visibility_changed.connect(hide_all_reset_buttons)
	#Settings.settings_loaded.connect(set_all_buttons_visibility)
	#set_all_buttons_visibility()
	#print("ready")
	#hide_all_reset_buttons()
	pass


func get_button_from_key(key : String, reset_button : bool) -> Button:
	if not key_button_pairs.has(key):
		printerr("can't get default button. Unknown key: ", key)
		return null
	
	return key_button_pairs[key] [1] if reset_button else key_button_pairs[key] [0]
	
func set_all_buttons_visibility() -> void:
	for key in key_paths.keys():
		#print ("key: ", key)
		var node_path = key_paths[key][0]
		var property_path = key_paths[key][1]
		var value = get_node(node_path).get_indexed(property_path)
		set_buttons_visibility(value, key)


func hide_all_reset_buttons() -> void:
	if Settings.visible == false:
		reset_submenu_button.disabled = true
		
		for key in key_paths.keys():
			var button : Button = get_button_from_key(key, true)
			button.disabled = true
	
#@warning_ignore("native_method_override")
#func get_class():
#	return "VideoSubMenu"
#
#@warning_ignore("native_method_override")
#func is_class(value):
#	return value == "VideoSubMenu"

# Saves any settings from any slider:
func slider_change(value: float, key : String) -> void:
	var key_array = key_paths[key]
	var node_path = key_array[0]
	var property_path = key_array[1]
	
	var save_value = [node_path, property_path, value]
	
	var settings_key = Settings.get_setting_key_from_submenu_or_null(self) # Will be "video_settings" or "key_map_setting", etc.
	if settings_key == null:
		printerr("cannot save setting")
		return
	Settings.settings[settings_key] [key] = save_value
	
	set_buttons_visibility(value, key)

# For any setting:
func set_to_default(key : String) -> void:
	Settings.default_single_setting(key, self)

# For any setting:
func reset(key : String) -> void:
	Settings.reset_single_setting(key, self)


func _on_default_submenu_pressed() -> void:
	var settings_key = Settings.get_setting_key_from_submenu_or_null(self)
	if settings_key == null:
		return
	Settings.default_specific_setting(settings_key)

func _on_reset_submenu_pressed() -> void:
	var settings_key = Settings.get_setting_key_from_submenu_or_null(self)
	if settings_key == null:
		return
	Settings.reset_specific_setting(settings_key)



## For specific settings:
#func fov_slider_change(value: float) -> void:
#	fov_slider_label.text = str(value)
#
## Getters:
#func get_fov() -> float:
#	return fov_slider.value


############################ Button disabled/visibility:
# Later: change function so doesn't need to repeat code for default and reset
func set_buttons_visibility(value: float, key : String) -> void:
	# Check for default button:
	var default_button : Button = get_button_from_key(key ,false)
	var default_value = get_default_value_of_property_key(key)
	
	if value == default_value:
		#print ("vale is default")
		# Remove default button's visibility, value is already default.
		default_property_changes.erase(key) # it's fine to call erase even if it doesn't have key.
		
		# Hide the property default button:
		default_button.disabled = true
		
		# Check if submenu's default button needs to be set to invisible too:
		if default_property_changes.is_empty():
			default_submenu_button.disabled = true
	else:	
		#print ("value is not default")
		default_property_changes[key] = null # create a key inside. Needs a value (but it is arbitrary, use smallest),
		
		#print ("created default key: ", default_property_changes)
		
		# Show the property default button:
		default_button.disabled = false
		# Show the submenu default button:
		default_submenu_button.disabled = false
	
	# Check for reset button: unless NOT in settings in the first place.
	if States.settings_menu_state == States.SettingsMenuStates.NONE:
		# Check for global default and reset's visibility
		Settings.set_default_and_reset_button_visibility()
		return
	
	var reset_button : Button = get_button_from_key(key ,true)
	var reset_value = get_reset_value_of_property_key(key)
	if value == reset_value:
		# Remove default button's visibility, value is already default.
		revert_property_changes.erase(key) # it's fine to call erase even if it doesn't have key.
		
		# Hide the property default button:
		reset_button.disabled = true
		
		# Check if submenu's default button needs to be set to invisible too:
		if revert_property_changes.is_empty():
			reset_submenu_button.disabled = true
	else:
		revert_property_changes[key] = null # create a key inside. Needs a value (but it is arbitrary, use smallest),
		# Show the property default button:
		reset_button.disabled = false
		# Show the submenu default button:
		reset_submenu_button.disabled = false
	
	# Check for global default and reset's visibility
	Settings.set_default_and_reset_button_visibility()

func get_default_value_of_property_key(key : String):
	var settings_key = Settings.get_setting_key_from_submenu_or_null(self)
	if settings_key == null:
		printerr("cant check default value!")
		return
	
	if not Settings.default_setting.has(settings_key):
		printerr("can't get : ", settings_key, " inside default_setting")
		print ("default settings: ", Settings.default_setting)
		return
	
	var submenu_default_settings = Settings.default_setting[settings_key]
	
	var default_save_value = submenu_default_settings[key]  #[node_path, property_path, value]
	
	return default_save_value[2]


func get_reset_value_of_property_key(key : String):
	var settings_key = Settings.get_setting_key_from_submenu_or_null(self)
	if settings_key == null:
		printerr("cant check reset value!")
		return
	var submenu_default_settings = Settings.reset_setting[settings_key]
	
	var default_save_value = submenu_default_settings[key]  #[node_path, property_path, value]
	
	return default_save_value[2]

