extends Node3D

@export var target_width: int = 320
@export var target_height: int = 180

func _ready():
    # Get the viewport
    var viewport = get_viewport()
    
    # Set low resolution
    viewport.size = Vector2i(target_width, target_height)
    
    # Enable depth and normal textures for outline shader
    # This is done in Project Settings, but we can verify here
    print("Pixel art setup complete!")
    print("Resolution: ", target_width, "x", target_height)
