
extends Node3D
var ourplayer=null
var time=0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time+=delta
	$Texture.material_override.set_shader_parameter("time",time)
	#finding player of game instance
	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null:
				if e.get_node_or_null("MultiplayerSynchronizer").is_multiplayer_authority():
					#multiplayer authority c:
					ourplayer=e
	else:
		position=Vector3(ourplayer.position.x,position.y,ourplayer.position.z)
		#follow player on x and z coordinates
	$Texture.material_override.set_shader_parameter("offset",position)
	#make it look like it's just infinite(offseting)
	pass
