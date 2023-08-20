extends MarginContainer

# WARNING: Does not currently support multiple keys for a single action.

@export var action_list : VBoxContainer
@export var base_action : HBoxContainer

# All these actions should MATCH the name in the InputMap in project settings.
# The order in whch they appear here will be the order they appear in the menu.
# If there is a way to get all the actions from the project settings without
# getting any of the build-in ones, should probably get the actions like that
# instead of naming them all here. 
var action_names : Array[StringName] = [
	"perspective_change",
	"crouch",
	"jump",
	"inventory",
	"interact",
	"attack",
	"zoom",
	"inv_1",
	"inv_2",
	"inv_3",
	"inv_4",
	"inv_5",
]

func _ready() -> void:
	base_action.visible = false
	build_action_list()

# Loops through action_names.
# Generates new nodes and places them inside the action_list node.
# Creates the new nodes by using base_action, duplicates it and modifies it for
# each action.
func build_action_list() -> void:
	# get all action_names actions and their keys from InputMap.
	var actions : Dictionary = get_actions()
	
	for action in actions.keys():
		var action_node : HBoxContainer = base_action.duplicate()
		action_list.add_child(action_node)
		
		# Rename the name label:
		var name_label : Label = action_node.get_child(0)
		name_label.set_text(action)
		
		# Rename the key label:
		var key_label : Label = action_node.get_child(1)
		var key : String = actions[action][0] # Just gets the first key assigned to it... for now.
		key_label.set_text(key)
		
		var remap_button : Button = action_node.get_child(2)
		remap_button.pressed.connect(remap_action.bind(action))
		
		action_node.visible = true

func remap_action(action : String) -> void:
	print ("remap: ", action)

# Gets all events for actions inside action_names from the InputMap.
# Returns all actions (keys) and their events (values) as a dictionary. 
func get_actions() -> Dictionary:
	var actions : Dictionary
	
	for action in action_names:
		if not InputMap.has_action(action):
			printerr("Key_Mapper: action is not in InputMap: ", action)
			continue
		
		var action_events : Array[InputEvent] = InputMap.action_get_events(action)
		
		var action_keys : Array[String] 
		
		# For every single action, get all the keys linked to it:
		for action_event in action_events: 
			if action_event is InputEventKey:
				var key_string = OS.get_keycode_string(action_event.get_physical_keycode())
				
				if not key_string.is_empty() and not action_keys.has(key_string):
					action_keys.append(key_string)
#				else:
#					print ("--problem: ", action_event, " | ", action_event.get_physical_keycode())
				
			else:
				action_keys.append(action_event.as_text())
		
		actions[action] = action_keys
		
	return actions
	






