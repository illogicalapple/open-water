@tool
extends Area3D
var ourplayer=null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null:
				ourplayer=e
	else:
		position=Vector3(ourplayer.position.x,position.y,ourplayer.position.z)
	$ff.material_override.set_shader_parameter("offset",position)
	
	pass
