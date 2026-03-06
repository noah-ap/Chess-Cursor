extends Camera3D

@export var pixel_size: int = 4  # Pixels per world unit
@export var low_res_width: int = 320
@export var low_res_height: int = 180

var snap_offset: Vector2

func _ready():
    # Set up orthogonal projection for isometric view
    projection = PROJECTION_ORTHOGONAL
    size = 10.0  # Adjust based on your scene size
    
    # Set up isometric angle (typical isometric: 30 degrees)
    rotation_degrees = Vector3(-30, 45, 0)
    position = Vector3(8, 8, 8)
    
    # Look at origin
    look_at(Vector3(0, 0, 0))

func _process(_delta):
    # Snap camera to pixel grid
    var world_pos = global_transform.origin
    var pixel_world_size = 1.0 / pixel_size
    
    # Calculate snap error
    var snapped_x = floor(world_pos.x / pixel_world_size) * pixel_world_size
    var snapped_z = floor(world_pos.z / pixel_world_size) * pixel_world_size
    
    snap_offset.x = world_pos.x - snapped_x
    snap_offset.y = world_pos.z - snapped_z
    
    # Apply snap (optional - comment out if you want smooth movement)
    # global_transform.origin.x = snapped_x
    # global_transform.origin.z = snapped_z
