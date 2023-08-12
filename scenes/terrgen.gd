extends Node3D

var rng=RandomNumberGenerator.new()
var ourplayer=null
var spawned=[]
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.


func searchisland():
	var numbersx=Vector2(floor(global_position.x-40),floor(global_position.x+40))
	var numbersz=Vector2(floor(global_position.z-40),floor(global_position.z+40))
	for x in range(numbersx.x,numbersx.y):for z in range(numbersz.x,numbersz.y):
		rng.state=12745*x+67395*z
		var random=rng.randi_range(0,10000)
		if random==150 and not Vector2(x,z)in spawned:
			var island=preload("res://scenes/components/terrain.tscn").instantiate()
			get_parent().add_child(island)
			island.coordinate=Vector2(x,z)
			island.global_position=Vector3(x,-21,z)
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
