extends Camera3D

# Camera settings
@export var orbit_distance: float = 11.0  # Distance from board center
@export var orbit_height: float = 8.0     # Height above board
@export var rotation_speed: float = 15.0  # Degrees per key press
@export var smooth_rotation: bool = true  # Smooth rotation animation
@export var rotation_lerp_speed: float = 5.0  # Speed of smooth rotation
@export var auto_rotation_speed: float = 30.0  # Degrees per second for auto-rotation

# Board center to orbit around
@export var look_target: Vector3 = Vector3(0, 0.2, 0)  # Slightly higher to center board (2.5%)

# Current rotation angle (in degrees)
var current_angle: float = 45.0  # Start at 45 degrees (corner view)
var target_angle: float = 45.0
var auto_rotating: bool = false

func _ready():
	# Set up orthogonal projection
	projection = PROJECTION_ORTHOGONAL
	current = true
	
	# Set initial position
	_update_camera_position()

func _process(delta):
	# Auto-rotation (clockwise)
	if auto_rotating:
		target_angle += auto_rotation_speed * delta
	
	# Smooth rotation
	if smooth_rotation:
		current_angle = lerp(current_angle, target_angle, rotation_lerp_speed * delta)
	else:
		current_angle = target_angle
	
	# Update camera position
	_update_camera_position()

func _input(event):
	# Handle key presses for rotation
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_Q:
			auto_rotating = false  # Stop auto-rotation when manually rotating
			target_angle += rotation_speed
			_snap_to_15_degrees()
		elif event.keycode == KEY_E:
			auto_rotating = false  # Stop auto-rotation when manually rotating
			target_angle -= rotation_speed
			_snap_to_15_degrees()
		elif event.keycode == KEY_SPACE:
			if auto_rotating:
				# Stop auto-rotation and snap to nearest 15-degree increment
				auto_rotating = false
				_snap_to_15_degrees()
			else:
				# Start auto-rotation
				auto_rotating = true

func _update_camera_position():
	# Convert angle to radians
	var angle_rad = deg_to_rad(current_angle)
	
	# Calculate position on circle around target
	var x = cos(angle_rad) * orbit_distance + look_target.x
	var z = sin(angle_rad) * orbit_distance + look_target.z
	var y = orbit_height + look_target.y
	
	# Set position
	position = Vector3(x, y, z)
	
	# Look at target
	look_at(look_target, Vector3.UP)

# Public methods to control camera
func rotate_left():
	target_angle += rotation_speed

func rotate_right():
	target_angle -= rotation_speed

func set_angle(angle_degrees: float):
	target_angle = angle_degrees
	if not smooth_rotation:
		current_angle = angle_degrees

func _snap_to_15_degrees():
	# Snap to nearest 15-degree increment
	var snapped = round(target_angle / rotation_speed) * rotation_speed
	target_angle = snapped
	if not smooth_rotation:
		current_angle = snapped
