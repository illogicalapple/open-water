extends CharacterBody3D

@export var health = 100
@export var weapon : Weapon

@onready var hitbox : Area3D = $HitBox
@onready var hurt_audio : AudioStreamPlayer3D = $PlayerHurtAudio

var speed = 5
#var mouse_sensitivity = 0.5
var veloc = Vector3(0,0,0)
var jumpheight = 20
@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer
var selected = null




func _ready():
	var damage_logic = HealthNode.new(health, hitbox, self)
	damage_logic.damage_taken.connect(damage_taken)
	damage_logic.died.connect(died)
	
	States.set_to_in_game() # starts the game (change game states)
	synchronizer.set_multiplayer_authority(str(name).to_int()) # connects to host
	camera.current = synchronizer.is_multiplayer_authority() # if it didn't work, the camera doesn't exist ig
	if synchronizer.is_multiplayer_authority(): 
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # it captures the mouse
		Character.player=self

## Called from damage_logic node's damage_taken signal.
func damage_taken(damage_taken : float, current_health : float) -> void:
	health = current_health
	print ("player took damage: [", damage_taken, "] health = ", health)
	
	# Randomize pitch before playing for more variance.
	hurt_audio.stop()
	hurt_audio.pitch_scale = randf_range(1 - 0.3, 1 + 0.3) 
	hurt_audio.play()

## Called from damage_logic node's died signal.
func died() -> void:
	print_debug("player died: this currently does nothing.")
	# Handle player death sounds and death animations from here...
	


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
		if (States.character_state==States.CharacterStates.DRIVING
		 and Input.is_action_pressed("jump")
		):States.character_state=States.CharacterStates.NORMAL
		
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
		
		if not States.character_state==States.CharacterStates.DRIVING:
			set_velocity(veloc)
			set_up_direction(Vector3.UP)
			
			move_and_slide()
		else:
			var raft=get_parent().get_node("Raft")
			var raftveloc=Vector2()
			
			
			if Input.is_key_pressed(KEY_W):raftveloc.x=10
			if Input.is_key_pressed(KEY_S):raftveloc.x=-10
			if Input.is_key_pressed(KEY_D):raftveloc.y=-1
			if Input.is_key_pressed(KEY_A):raftveloc.y=1
			
			
			raft.global_position+=Vector3(raftveloc.x,0,0).rotated(Vector3.UP,raft.global_rotation.y)*delta
			raft.rotation.y+=raftveloc.y*delta
		# important: syncs the position for multiplayer
		synchronizer.position = global_position
		if abs(veloc.x)<0.1:veloc.x=0
		if abs(veloc.z)<0.1:veloc.z=0
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
		
		if Input.is_action_just_pressed("attack"):
			weapon.attack()

func _process(delta):
	if synchronizer.is_multiplayer_authority():
		if $Camera3D/RayCast3D.is_colliding():
			var collider=$Camera3D/RayCast3D.get_collider()
			if collider.is_in_group("interact"):
				collider.selected=true
				if selected !=null and selected!=collider:
					selected.selected=false
				
				selected=collider
		else:
			if selected !=null:
				selected.selected=false
			selected=null



