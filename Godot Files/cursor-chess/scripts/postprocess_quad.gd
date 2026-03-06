extends MeshInstance3D

# Script to dynamically size the postprocess quad to cover the full camera view
func _ready():
	_update_quad_size()

func _update_quad_size():
	var camera = get_parent()
	if not camera is Camera3D:
		return
	
	# Get viewport size
	var viewport = get_viewport()
	if not viewport:
		return
	
	var viewport_size = viewport.get_visible_rect().size
	var aspect_ratio = viewport_size.x / viewport_size.y
	
	# For orthogonal camera, calculate the size needed
	if camera.projection == Camera3D.PROJECTION_ORTHOGONAL:
		var camera_height = camera.size
		var camera_width = camera_height * aspect_ratio
		
		# Make quad much larger to ensure full coverage with no visible edges
		# Use the larger dimension and add plenty of margin
		var quad_size = max(camera_width, camera_height) * 2.5
		
		if mesh is QuadMesh:
			mesh.size = Vector2(quad_size, quad_size)
