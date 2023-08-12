# OpenWater Documentation

OpenWater is a multiplayer game where you explore a procedurally generated world, find resources, progress into different domains of the world (the land, the ocean, space and hell), and most importantly, drive around on a raft.

# Settings

The settings scene is built with multiple submenus. Each submenu button (video, controls, sound, etc.) displays its corresponding submenu scene (**video_submenu.tscn, controls_submenu.tscn, sound_submenu.tscn**, etc.) which are embedded into the settings scene. These submenus contain their own relevant, individual settings.

## Individual Settings
Individual settings are settings inside the submenu's that the user can change. For example, the FOV setting inside the **video_submenu.tscn** scene is an individual setting. 

### Default and Reset Values
Each individual setting has a default value and a reset value. 

The **default value** is the value that the game starts with for that setting. For example, the FOV setting inside the **video_submenu.tscn** may start with the value 15. That value is always considered the default value for that individual setting for the entirety of the game. 

The **reset value** is the value that the individual setting is set to when the **settings.tscn** scene is shown. For example, the FOV setting may be set to 20 when the settings scene is opened (the user changed it from the default 15). In this case, FOV's  reset value is 20. If the user changes it to 25 and closes the settings scene, when the settings scene is opened once again, FOV's reset value will now be 25. 

### Default and Reset Buttons
Each individual setting has a default value and a reset button. These buttons reset the value to the default/reset value of that individual setting.

Each submenu has its own default button and reset button. These buttons reset the values of **all individual settings inside that submenu** to their default/reset values. 

The settings menu has its own default and reset button. These buttons reset the values of **all individual settings inside all submenus** to their default/reset values.


## Step-by-Step Guide to Adding your own Setting

### Making a submenu:
coming soon...
### Making an individual setting inside a submenu:

Step 1: Duplicate an already existing setting in the scene tree and use it as the base for your new setting. 
* This way, the default and reset values are already made and their signals are already connected to the appropriate function.
* Edit the "Label" node to say the name of the setting (e.g., 'FOV', or 'shadow', etc.)

Step 2: Decide on the node being used to change the value: a slider, a checkbox, etc.
* Replace the already existing node inside your duplicate with the chosen one. 

Step 3: Add relevant variables into the submenu. 
* Add in a variable for the node that you are using to change the value under `@export_category("Property Nodes")`. Drag it into the inspector. 
* Add in the default button node under `@export_group("Default Buttons" , "default_")`. Drag it into the inspector. 
* Add in the reset button node under `@export_group("Reset Buttons" , "reset_")`. Drag it into the inspector. 
* Add in the appropriate key-value pair inside of the **`sub_menu_key_paths`** dictionary. It is best to simply copy-paste an already existing key-value pair here and use it as the the base for your new setting. The **KEY** you use here MUST BE UNIQUE.
* Optional: You make also want to add a getter function for your setting to get the value it is set to in this submenu script. 

Step 4: Connecting the signal.
* The node you are using to modify the value (e.g., a slider, a checkbox, etc.) must now be connected to the submenu's **`setting_changed`** function. It is important to remember that this function is inherited. You won't see it in the submenu, but you will see it in **settings_submenu.gd** which all submenu's inherit from. 
* When connecting the signal to this function, you must also add in an extra call argument. When connecting from the editor, click on the "advanced' toggle, add in a string as an extra call argument and paste in the unique **KEY** for this setting for it (the one you used in the dictionary).
* The signal that you use here must also pass the value! For a checkbutton you may accidentally connect the **pressed()** signal, which will not work. Instead, use the **toggled(button_pressed: bool)** signal which sends the value as well. If your node does not have a signal like that, make your own and connect that to the  **`setting_changed`** function with the value as parameter 1 and the key as parameter 2. 

Done! You have now created a individual setting for your submenu! It is integrated with the submenu and settings scene so that it's value changes allow for all levels of the default/reset buttons to react appropriately. 
