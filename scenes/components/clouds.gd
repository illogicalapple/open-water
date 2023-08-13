extends MeshInstance3D
var ourplayer=null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null and e.get_node_or_null("MultiplayerSynchronizer").is_in_group("playersync"):
				if e.get_node_or_null("MultiplayerSynchronizer").is_multiplayer_authority():
					#multiplayer authority c:
					ourplayer=e
	else:
		material_override.set_shader_parameter("offset",Vector2(position.x,position.z))
	pass
