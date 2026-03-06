extends MeshInstance3D

# Script to keep the outline quad aligned with the camera
func _ready():
	# Make sure the quad is visible and positioned correctly
	pass

func _process(_delta):
	# Keep the quad aligned with the camera
	var camera = get_parent()
	if camera is Camera3D:
		# Position at camera's near plane
		position = Vector3(0, 0, -camera.near - 0.01)
		# Size the quad to match the camera's view
		if camera.projection == Camera3D.PROJECTION_ORTHOGONAL:
			var quad_size = camera.size * 2.0
			if mesh is QuadMesh:
				mesh.size = Vector2(quad_size, quad_size)
