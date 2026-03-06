extends ColorRect

@export var outline_threshold: float = 0.01
@export var outline_color: Color = Color.BLACK
@export var outline_width: float = 1.0

func _ready():
	# Get the material and update shader parameters
	var mat = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("outline_threshold", outline_threshold)
		mat.set_shader_parameter("outline_color", outline_color)
		mat.set_shader_parameter("outline_width", outline_width)

func _process(_delta):
	# Update in real-time if you want to tweak in inspector
	var mat = material as ShaderMaterial
	if mat:
		mat.set_shader_parameter("outline_threshold", outline_threshold)
		mat.set_shader_parameter("outline_color", outline_color)
		mat.set_shader_parameter("outline_width", outline_width)
