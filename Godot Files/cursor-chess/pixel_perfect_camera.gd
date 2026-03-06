extends Camera3D

@export var pixel_size: int = 4  # Pixels per world unit
@export var low_res_width: int = 320
@export var low_res_height: int = 180

# Camera mode
@export_enum("Static", "Rotating") var camera_mode: int = 0

# Rotation settings (for rotating mode)
@export var rotation_speed: float = 0.3  # Rotation speed in radians per second
@export var orbit_distance: float = 12.0  # Distance from board center
@export var orbit_height: float = 10.0  # Height above board

# Static camera settings
@export var static_angle: float = -135.0  # Horizontal angle (degrees)
@export var static_pitch: float = -35.0   # Vertical angle (degrees)

# Board center (chess board is centered around origin after board script runs)
@export var look_target: Vector3 = Vector3(0, 0, 0)

var rotation_angle: float = 0.0
var snap_offset: Vector2

func _ready():
    # Set up orthogonal projection for isometric/pixel art view
    projection = PROJECTION_ORTHOGONAL
    size = 12.0  # Adjust to fit chess board
    
    # Initialize rotation angle for rotating mode
    rotation_angle = deg_to_rad(static_angle + 135.0)
    
    # Set initial position
    if camera_mode == 0:  # Static
        _set_static_position()

func _process(delta):
    if camera_mode == 1:  # Rotating
        # Rotate camera around board center
        rotation_angle += rotation_speed * delta
        
        # Calculate camera position in a circle
        var x = cos(rotation_angle) * orbit_distance + look_target.x
        var z = sin(rotation_angle) * orbit_distance + look_target.z
        position = Vector3(x, orbit_height, z)
        
        # Look at board center
        look_at(look_target)
    
    # Pixel snapping (optional)
    _apply_pixel_snap()

func _set_static_position():
    # Convert angle to radians
    var angle_rad = deg_to_rad(static_angle)
    
    # Calculate position
    var x = cos(angle_rad) * orbit_distance + look_target.x
    var z = sin(angle_rad) * orbit_distance + look_target.z
    position = Vector3(x, orbit_height, z)
    
    # Look at board center
    look_at(look_target)

func _apply_pixel_snap():
    var world_pos = global_transform.origin
    var pixel_world_size = 1.0 / pixel_size
    
    var snapped_x = floor(world_pos.x / pixel_world_size) * pixel_world_size
    var snapped_z = floor(world_pos.z / pixel_world_size) * pixel_world_size
    
    snap_offset.x = world_pos.x - snapped_x
    snap_offset.y = world_pos.z - snapped_z

# Call this to switch between modes
func set_rotating(enabled: bool):
    camera_mode = 1 if enabled else 0
    if camera_mode == 0:
        _set_static_position()
