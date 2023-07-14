extends CharacterBody3D

var speed = 10
var mouse_sensitivity = 0.5

@onready var camera = $Camera3D
@onready var synchronizer = $MultiplayerSynchronizer

func _ready():
	synchronizer.set_multiplayer_authority(str(name).to_int())
	camera.current = synchronizer.is_multiplayer_authority()
	if synchronizer.is_multiplayer_authority(): Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	if synchronizer.is_multiplayer_authority():
		var direction = Vector3.ZERO
		if not is_on_floor(): direction.y -= 0.4
		if is_on_floor() and Input.is_key_pressed(KEY_SPACE): direction.y += 10
		if Input.is_key_pressed(KEY_W): direction -= global_transform.basis.z
		elif Input.is_key_pressed(KEY_S): direction += global_transform.basis.z
		if Input.is_key_pressed(KEY_A): direction -= global_transform.basis.x
		elif Input.is_key_pressed(KEY_D): direction += global_transform.basis.x
		direction = (direction*speed)
		set_velocity(direction)
		set_up_direction(Vector3.UP)
		move_and_slide()
		synchronizer.position = global_position



func _input(event):
	if synchronizer.is_multiplayer_authority():
		if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE else Input.MOUSE_MODE_VISIBLE
		if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			rotate_y(-deg_to_rad(event.relative.x) * mouse_sensitivity)
			synchronizer.y_rotation = rotation.y
			camera.rotate_x(-deg_to_rad(event.relative.y) * mouse_sensitivity)