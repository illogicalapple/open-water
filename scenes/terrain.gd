
extends MeshInstance3D
var ourplayer=null
var time=0
# Called when the node enters the scene tree for the first time.
var noise=FastNoiseLite.new()
var distance_per_points=20
func gn(x,z) ->float:#shortening get_noise_2d
#	x*=distance_per_points
#	z*=distance_per_points
	x+=floor(global_position.x/distance_per_points)
	z+=floor(global_position.z/distance_per_points)
	return noise.get_noise_2d(x,z)*20

func _ready():
	var arr_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var index=PackedInt32Array()
	var usedindex=0
	for x in range(-5,5):
		for z in range(-5,5):
			
			
			
			vertices.push_back(Vector3(x,gn(x,z),z)*distance_per_points)
			vertices.push_back(Vector3(x+1,gn(x+1,z),z)*distance_per_points)
			vertices.push_back(Vector3(x,gn(x,z+1),z+1)*distance_per_points)
			
			vertices.push_back(Vector3(x+1,gn(x+1,z+1),z+1)*distance_per_points)
			vertices.push_back(Vector3(x,gn(x,z+1),z+1)*distance_per_points)
			vertices.push_back(Vector3(x+1,gn(x+1,z),z)*distance_per_points)
			
			
			
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
	$StaticBody3D/CollisionShape3D.shape=arr_mesh.create_trimesh_shape()

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#finding player of game instance
	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null and e.get_node_or_null("MultiplayerSynchronizer").is_in_group("playersync"):
				if e.get_node_or_null("MultiplayerSynchronizer").is_multiplayer_authority():
					#multiplayer authority c:
					ourplayer=e
	else:
		var prevpos=position
		var pos=floor(Vector3(ourplayer.position.x,position.y,ourplayer.position.z)/distance_per_points)*distance_per_points
		pos.y=position.y 
		position=pos
		if position!=prevpos:
			_ready()
		#follow player on x and z coordinates
#	self.material_override.set_shader_parameter("offset",position)
