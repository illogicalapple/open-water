extends CharacterBody3D

var speed = 10
#var mouse_sensitivity = 0.5
var veloc=Vector3(0,0,0)
var jumpheight=30
@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer

func _ready():
	States.set_to_in_game()
	synchronizer.set_multiplayer_authority(str(name).to_int())
	camera.current = synchronizer.is_multiplayer_authority()
	if synchronizer.is_multiplayer_authority(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if synchronizer.is_multiplayer_authority():
		if States.character_state == States.CharacterStates.NOCLIP: $CollisionShape3D.disabled = true
		else: $CollisionShape3D.disabled = false
		var can_fly = (States.character_state == States.CharacterStates.FLY or States.character_state == States.CharacterStates.NOCLIP)
		var direction = Vector3.ZERO
		if not is_on_floor():
			if not can_fly:
				direction.y -= 0.4
			if Input.is_action_pressed("crouch") and can_fly:
				position.y -= 15 * delta
		if can_fly:
			velocity.y = 0
			if Input.is_action_pressed("jump"): position.y += 15 * delta
		else:
			if is_on_floor() and Input.is_key_pressed(KEY_SPACE): direction.y +=jumpheight
		if Input.is_key_pressed(KEY_W): direction -= global_transform.basis.z
		elif Input.is_key_pressed(KEY_S): direction += global_transform.basis.z
		if Input.is_key_pressed(KEY_A): direction -= global_transform.basis.x
		elif Input.is_key_pressed(KEY_D): direction += global_transform.basis.x
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
		synchronizer.position = global_position
		
		camera.fov = Settings.video_submenu.get_fov()
		#camera.fov = Settings.video_settings[Settings.VideoSettings.FOV]

func _unhandled_input(event: InputEvent) -> void:
	if synchronizer.is_multiplayer_authority():
#		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
#			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			var mouse_sensitivity = Settings.video_submenu.get_mouse_sensitivity()
			
			rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
			synchronizer.y_rotation = rotation.y
			camera.rotate_x(-deg_to_rad(event.relative.y) * mouse_sensitivity)
	if Input.is_action_just_pressed("perspective_change"):
		$Camera3D.current=!$Camera3D.current
		$Camera3D/thirdperson.current=!$Camera3D.current





