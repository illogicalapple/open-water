extends Node3D

var rng=RandomNumberGenerator.new()
var ourplayer=null
var spawned=[]
var spawndistance=80
var maxdistance = 100000
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


func searchisland():
	var x = rng.randf_range(spawndistance, maxdistance)
	rng.randomize()
	var z = rng.randf_range(spawndistance, maxdistance)
	if not Vector2(x,z) in spawned:
		var island=preload("res://scenes/components/terrain.tscn").instantiate()
		island.position=Vector3(x,-15,z)
		get_parent().add_child(island)
		island.coordinate=Vector2(x,z)
		island.noiseseed=rng.state
		spawned.append(Vector2(x,z))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ourplayer==null:
		for e in get_parent().get_children():
			if e.get_node_or_null("MultiplayerSynchronizer")!=null and e.get_node_or_null("MultiplayerSynchronizer").is_in_group("playersync"):
				if e.get_node_or_null("MultiplayerSynchronizer").is_multiplayer_authority():
					#multiplayer authority c:
					ourplayer=e
	else:
		var prevpos=position
		var pos=floor(Vector3(ourplayer.position.x,position.y,ourplayer.position.z))
		pos.y=position.y 
		position=pos
		if position!=prevpos:
			searchisland()
		#follow player on x and z coordinates
#	self.material_override.set_shader_parameter("offset",position)
	pass
