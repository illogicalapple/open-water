extends StaticBody3D

var selected=false
var usedseat=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if selected:
		$Cube.material_override.set_shader_parameter("whiten",1)
	if not selected:
		$Cube.material_override.set_shader_parameter("whiten",0)
	if States.character_state==States.CharacterStates.DRIVING:
		if usedseat:
			Character.player.global_position=$sitpoint.global_position
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index==MOUSE_BUTTON_RIGHT:
			States.character_state=States.CharacterStates.DRIVING
			usedseat=true
