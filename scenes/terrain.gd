
extends MeshInstance3D
var ourplayer=null
var time=0
# Called when the node enters the scene tree for the first time.
var noise=FastNoiseLite.new()
var distance_per_points=20
var width=20
var depth=20
var noiseseed=randi()
var maxload=10
var firstpos:Vector3
var globalpos=floor(position/distance_per_points)
var coordinate=Vector2()
func gn(x,z) ->float:#shortening get_noise_2d
#	x*=distance_per_points
#	
	var globalx=x+floor(position.x/distance_per_points)
	var globalz=z+floor(position.z/distance_per_points)
	var data= noise.get_noise_2d(globalx,globalz)*20
	x=globalx-firstpos.x
	z=globalz-firstpos.z
	
#	return (data/(width/2)*abs(abs(width/2)-x))+data+(data/(depth/2)*abs(abs(depth/2)-z))/3
	var data2=(data/(width/2)*abs(abs(width/2)-abs(x)))
	data2=(data2/(depth/2)*abs(abs(depth/2)-abs(z)))
	return data2

func _ready():
	
	globalpos=floor(position/distance_per_points)
	var halfmxl=maxload/2
	firstpos=globalpos-Vector3(halfmxl,0,halfmxl)
	firstpos+=Vector3(width/2,0,depth/2)
	for e in get_parent().get_children():
		
		if e.is_in_group("terrain") and e!=self:if abs(e.position.x-position.x)<width or abs(e.position.z-position.z)<depth:
			queue_free()
	terrgen()
	

			# Initialize the ArrayMesh.
			

	pass # Replace with function body.
func terrgen():
	
	globalpos=floor(position/distance_per_points)
	var arr_mesh = ArrayMesh.new()
	var vertices = PackedVector3Array()
	var index=PackedInt32Array()
	var usedindex=0
	noise.seed=noiseseed
	for x in range(-floor(maxload/2),ceil(maxload/2)):
		for z in range(-floor(maxload/2),ceil(maxload/2)):
			
			
			
			vertices.push_back(Vector3(x,gn(x,z),z)*distance_per_points)
			vertices.push_back(Vector3(x+1,gn(x+1,z),z)*distance_per_points)
			vertices.push_back(Vector3(x,gn(x,z+1),z+1)*distance_per_points)
			
			vertices.push_back(Vector3(x+1,gn(x+1,z+1),z+1)*distance_per_points)
			vertices.push_back(Vector3(x,gn(x,z+1),z+1)*distance_per_points)
			vertices.push_back(Vector3(x+1,gn(x+1,z),z)*distance_per_points)
			
			
			
			for i in range(6):
				
				index.push_back(usedindex)
				usedindex+=1
			
	var arrays = []
	arrays.resize(Mesh.ARRAY_MAX)
	arrays[Mesh.ARRAY_VERTEX] = vertices
	arrays[Mesh.ARRAY_INDEX]=index
		# Create the Mesh.
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var m = self
	m.mesh = arr_mesh
	$StaticBody3D/CollisionShape3D.shape=arr_mesh.create_trimesh_shape()
				
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	#finding player of game instance
	

	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null and e.get_node_or_null("MultiplayerSynchronizer").is_in_group("playersync"):
				if e.get_node_or_null("MultiplayerSynchronizer").is_multiplayer_authority():
					#multiplayer authority c:
					ourplayer=e
	else:
		var playerpos_inVector2=Vector2(ourplayer.position.x,ourplayer.position.z)
		var posinVector2=Vector2(position.x,position.z)
		if abs(playerpos_inVector2.x-posinVector2.x)>width*3 or abs(playerpos_inVector2.y-posinVector2.y)>depth*3:
			queue_free()
		var prevpos=position
		var pos=floor(Vector3(ourplayer.position.x,position.y,ourplayer.position.z)/distance_per_points)*distance_per_points
		
		pos.y=position.y 
		var clampvalue1=firstpos-Vector3(maxload/2,0,maxload/2)
		var clampvalue2=firstpos+Vector3(maxload/2,0,maxload/2)
		
		position.x=clamp(pos.x/distance_per_points,clampvalue1.x,clampvalue2.x)*distance_per_points
		position.z=clamp(pos.z/distance_per_points,clampvalue1.z,clampvalue2.z)*distance_per_points
		position.y=pos.y
		var globpos=position
		if position!=prevpos:
			terrgen()
		#follow player on x and z coordinates
#	self.material_override.set_shader_parameter("offset",position)
func delete():
	get_parent().get_node("terrgen").spawned.erase(coordinate)
