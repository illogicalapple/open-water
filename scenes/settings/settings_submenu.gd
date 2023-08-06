extends Control
class_name SettingsSubMenu

## Should be a class that SubMenu classes EXTEND.

var default_property_changes : Dictionary = {}
var revert_property_changes : Dictionary = {}

#@export_group("Labels") # Using category instead of group because don't want to expand group every time.

@export_group("Default Buttons") 
@export var default_submenu_button : BaseButton

@export_group("Reset Buttons") 
@export var reset_submenu_button : BaseButton

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


func get_button_from_key(key : String, reset_button : bool) -> BaseButton:
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
		set_property_button_enable(value, key, true) # For default buttons
		set_property_button_enable(value, key, false) # For reset buttons


func hide_all_reset_buttons() -> void:
	if Settings.visible == false:
		reset_submenu_button.disabled = true
		
		for key in key_paths.keys():
			var button = get_button_from_key(key, true)
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
	
	set_property_button_enable(value, key, true) # For default buttons
	set_property_button_enable(value, key, false) # For reset buttons

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


############################ Button disabled/visibility:
# Later: change function so doesn't need to repeat code for default and reset

## Checks to disable/enable the default and reset buttons for a specific property.
## To do so: checks if the property is deviated from its default/reset value.
func set_property_button_enable(value , key : String, default_button : bool) -> void:
	
	# If checking reset button, must ensure we are in settings menu.
	# Since reset settings only exists when in settings menu... No need to check otherwise.
	if not default_button: 
		if States.settings_menu_state == States.SettingsMenuStates.NONE:
			#print ("reset is null...")
			# Check for global default and reset's visibility
			set_submenu_button_enable()
			Settings.set_global_setting_buttons_enable(true) # for global default
			#Settings.set_global_setting_buttons_enable(false) # for global reset
			return
	
	# Gets default/reset value and button.
	var button : BaseButton 
	var property_value
	
	# Get the dictionary where all change from the default/reset values are stored.
	var property_change_dict : Dictionary = default_property_changes if default_button else revert_property_changes
	
	if default_button: 
		button = get_button_from_key(key ,false)
		property_value = get_default_value_of_property_key(key)
	else:
		button = get_button_from_key(key ,true)
		property_value = get_reset_value_of_property_key(key)
	
	# Check to see if the current value matches the default/reset value.
	# If is the same, no need to enable the button.
	if value == property_value:
		button.disabled = true
		property_change_dict.erase(key) # No longer deviated from the default/reset value so must erase key. 
	else:
		button.disabled = false
		# If different, then add to the changed_dictionary since it is changed from the default/reset value.
		property_change_dict[key] = null # create a key inside. Needs a value (but it is arbitrary, use smallest),
		# Show the submenu default button:
		default_submenu_button.disabled = false
	
	set_submenu_button_enable() # Check if submenu's default and reset key should be disabled too.
	# Check for global default and reset's visibility
	Settings.set_global_setting_buttons_enable(true) # for global default
	Settings.set_global_setting_buttons_enable(false) # for global reset
	

## Sets default/reset buttons to be enabled/disabled depending on if any property's
## are different from their default/reset value. If different, enabled, else disable.
func set_submenu_button_enable() -> void:
	if default_property_changes.is_empty():
		default_submenu_button.disabled = true
	else:
		default_submenu_button.disabled = false
	
	if revert_property_changes.is_empty():
		reset_submenu_button.disabled = true
	else:
		reset_submenu_button.disabled = false


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
	
	if not Settings.reset_setting.has(settings_key):
		printerr("reset settings does not exist yet... only exists when in settings menu.")
		return
		
	var submenu_default_settings = Settings.reset_setting[settings_key]
	
	var default_save_value = submenu_default_settings[key]  #[node_path, property_path, value]
	
	return default_save_value[2]

