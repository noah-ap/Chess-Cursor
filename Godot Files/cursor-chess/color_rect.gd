extends ColorRect

func _ready():
	var mat = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("outline_threshold", 0.05)
		mat.set_shader_parameter("outline_color", Color.BLACK)
		mat.set_shader_parameter("outline_width", 1.0)
