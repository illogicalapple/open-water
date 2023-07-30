extends StaticBody3D
var veloc=Vector2(0,0)
var noise1=FastNoiseLite.new()
var noise2=FastNoiseLite.new()
var player_pos: Vector3 = Vector3(0, 0, 0)
@onready var water=get_parent().get_node("Water/Texture").material_override
# Called when the node enters the scene tree for the first time.
func _ready():
	noise1.seed=randi()
	noise2.seed=randi()

	water.set_shader_parameter("noise1",ImageTexture.create_from_image(noise1.get_image(400,400)))
	water.set_shader_parameter("noise2",ImageTexture.create_from_image(noise2.get_image(400,400)))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if multiplayer.is_server():
		var dir=Vector2(0,0)
		for e in $colliders.get_children():
			var pos=e.global_position
			var debug=e.global_position
			if noise1.get_noise_2d(pos.x,pos.z)>pos.y-global_position.y:
				var difference=noise1.get_noise_2d(pos.x,pos.z)*5-pos.y-global_position.y
				if "x+" in e.name:
					dir.x+=difference
				else:
					dir.x-=difference
				if "z+"in e.name:
					dir.y+=difference
				else:
					dir.y-=difference
		
		veloc+=dir*delta/2
		veloc-=veloc.normalized()*delta
		rotation.x+=veloc.x*delta
		rotation.z+=veloc.y*delta
		rotation_degrees.x=clamp(rotation_degrees.x,-15,15)
		rotation_degrees.z=clamp(rotation_degrees.z,-15,15)
	if (noise1.get_noise_2d(player_pos.x, player_pos.y) + noise2.get_noise_2d(player_pos.x, player_pos.y)) / 2 > player_pos.y:
		get_parent().is_underwater = true
	else:
		get_parent().is_underwater = false
