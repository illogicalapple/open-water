@tool
extends MeshInstance3D
var ourplayer=null
var time=0
# Called when the node enters the scene tree for the first time.
var noise=FastNoiseLite.new()
var distance_per_points=20
func gn(x,z) ->float:#shortening get_noise_2d
	return noise.get_noise_2d(x,z)*20

func _ready():
	var arr_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var index=PackedInt32Array()
	var usedindex=0
	for x in range(10):
		for z in range(10):
			
			
			
			vertices.push_back(Vector3(x,gn(x,z),z)*10)
			vertices.push_back(Vector3(x+1,gn(x+1,z),z)*10)
			vertices.push_back(Vector3(x,gn(x,z+1),z+1)*10)
			
			vertices.push_back(Vector3(x+1,gn(x+1,z+1),z+1)*10)
			vertices.push_back(Vector3(x,gn(x,z+1),z+1)*10)
			vertices.push_back(Vector3(x+1,gn(x+1,z),z)*10)
			
			
			
			for i in range(6):
				
				index.push_back(usedindex)
				usedindex+=1
			
					

			# Initialize the ArrayMesh.
			
		var arrays = []
		arrays.resize(Mesh.ARRAY_MAX)
		arrays[Mesh.ARRAY_VERTEX] = vertices
		arrays[Mesh.ARRAY_INDEX]=index
		# Create the Mesh.
		arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
		var m = self
		m.mesh = arr_mesh

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#finding player of game instance
	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null:
				if e.get_node_or_null("MultiplayerSynchronizer").is_multiplayer_authority():
					#multiplayer authority c:
					ourplayer=e
	else:
		var pos=floor(Vector3(ourplayer.position.x,position.y,ourplayer.position.z)/distance_per_points)*distance_per_points
		pos.y=position.y 
		position=pos
		#follow player on x and z coordinates
#	self.material_override.set_shader_parameter("offset",position)
