extends Node3D

var rng=RandomNumberGenerator.new()
var ourplayer=null
var spawned=[]
var spawndistance=400
# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	pass # Replace with function body.

func generate():
	var a = rng.randi_range(15, 50)
	for i in range(a):
		#gen_island()
		pass

func searchisland():
	var numbersx=Vector2(floor(position.x-spawndistance),floor(position.x+spawndistance))
	var numbersz=Vector2(floor(position.z-spawndistance),floor(position.z+spawndistance))
	for x in range(numbersx.x,numbersx.y,20):for z in range(numbersz.x,numbersz.y,20):
		rng.state=(12745*x+67395*z)*3.45
		var random=rng.randi_range(1,3000)
		if random==150 and not Vector2(x,z)in spawned:
			var island=preload("res://scenes/components/terrain.tscn").instantiate()
			island.position=Vector3(x,-15,z)
			get_parent().add_child(island)
			island.coordinate=Vector2(x,z)
			
			island.noiseseed=(12745*x+67395*z)*3.45
			spawned.append(Vector2(x,z))
			print("shouldspawn")

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
			pass
		#follow player on x and z coordinates
#	self.material_override.set_shader_parameter("offset",position)
	pass
