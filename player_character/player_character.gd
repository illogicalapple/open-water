extends CharacterBody3D

var speed = 5
#var mouse_sensitivity = 0.5
var veloc=Vector3(0,0,0)
var jumpheight=20
@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer


func _ready():
	States.set_to_in_game() # starts the game (change game states)
	synchronizer.set_multiplayer_authority(str(name).to_int()) # connects to host
	camera.current = synchronizer.is_multiplayer_authority() # if it didn't work, the camera doesn't exist ig
	if synchronizer.is_multiplayer_authority(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # it captures the mouse

func _physics_process(delta):
	# this runs every tick
	
	if is_on_floor():
		veloc.y=0
	
	#uuuuum sorry i forgot to reset gravity on floor C:
	# ~M125
	
	
	if synchronizer.is_multiplayer_authority(): # always gotta check if you're connected
		if States.character_state == States.CharacterStates.NOCLIP: $CollisionShape3D.disabled = true # disables collisions in noclip mode (see states.gd)
		else: $CollisionShape3D.disabled = false # otherwise, it resets
		var can_fly = (States.character_state == States.CharacterStates.FLY or States.character_state == States.CharacterStates.NOCLIP) # can fly?
		var direction = Vector3.ZERO # resets direction, which is basically velocity
		if not is_on_floor(): # if it's not on the floor
			if not can_fly:
				direction.y -= 0.4 # gravity but only if you can't fly
			if Input.is_action_pressed("crouch") and can_fly:
				position.y -= 15 * delta # crouch to move down when you can fly
		if can_fly:
			velocity.y = 0 # no gravity
			if Input.is_action_pressed("jump"): position.y += 15 * delta
		else:
			if is_on_floor() and Input.is_action_pressed("jump"):
				direction.y += jumpheight
		# movement:
		if Input.is_key_pressed(KEY_W): direction -= global_transform.basis.z
		elif Input.is_key_pressed(KEY_S): direction += global_transform.basis.z
		if Input.is_key_pressed(KEY_A): direction -= global_transform.basis.x
		elif Input.is_key_pressed(KEY_D): direction += global_transform.basis.x
		# velocity stuff:
		veloc += (direction*speed)*delta*4
		if direction.x==0 and direction.z==0:
			var vel=veloc.normalized()
			vel.y=0
			veloc-=vel*speed*delta*4
		veloc.x=clamp(veloc.x,-speed,speed)
		veloc.z=clamp(veloc.z,-speed,speed)
		veloc.y=clamp(veloc.y,-speed*jumpheight,speed*jumpheight)
		if can_fly:
			veloc.y = 0
		set_velocity(veloc)
		set_up_direction(Vector3.UP)
		move_and_slide()
		# important: syncs the position for multiplayer
		synchronizer.position = global_position
		
		# sets fov
		camera.fov = Settings.video_submenu.get_fov()
		$Camera3D/thirdperson.fov = Settings.video_submenu.get_fov()
		get_parent().get_node("Raft").player_pos = position

func _unhandled_input(event: InputEvent) -> void:
	if synchronizer.is_multiplayer_authority():
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			# looking around!
			var mouse_sensitivity = Settings.controls_submenu.get_mouse_sensitivity()
			
			rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
			synchronizer.y_rotation = rotation.y # gotta sync the rotation
			camera.rotate_x(-deg_to_rad(event.relative.y) * mouse_sensitivity)
			if camera.rotation.x > PI / 2:
				camera.rotation.x = PI / 2
			if fmod(camera.rotation.x + PI, PI * 2) < PI / 2:
				camera.rotation.x = PI * 1.5
	
		if Input.is_action_just_pressed("perspective_change"):
			$Camera3D.current=!$Camera3D.current
			$Camera3D/thirdperson.current=!$Camera3D.current





