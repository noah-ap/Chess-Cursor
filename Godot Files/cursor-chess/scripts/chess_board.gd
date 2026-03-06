extends Node3D

# Board settings
@export var square_size: float = 1.0
@export var board_height: float = 0.1

# Materials
var light_square_material: ShaderMaterial
var dark_square_material: ShaderMaterial

# Reference to the toon shader
@export var toon_shader: Shader

# Board colors
@export var light_color: Color = Color(0.72, 0.60, 0.47)  # Light tan wood
@export var dark_color: Color = Color(0.35, 0.35, 0.38)   # Dark grey

# Stores references to squares
var squares: Array = []

func _ready():
	# Load the toon shader if not assigned
	if toon_shader == null:
		toon_shader = load("res://shaders/toon_piece.gdshader")
	
	# Create materials
	_create_materials()
	
	# Generate the board
	_generate_board()

func _create_materials():
	# Light square material
	light_square_material = ShaderMaterial.new()
	light_square_material.shader = toon_shader
	light_square_material.set_shader_parameter("albedo", light_color)
	light_square_material.set_shader_parameter("cuts", 2)
	light_square_material.set_shader_parameter("wrap", 0.0)
	
	# Dark square material
	dark_square_material = ShaderMaterial.new()
	dark_square_material.shader = toon_shader
	dark_square_material.set_shader_parameter("albedo", dark_color)
	dark_square_material.set_shader_parameter("cuts", 2)
	dark_square_material.set_shader_parameter("wrap", 0.0)

func _generate_board():
	# Clear existing squares
	for child in get_children():
		if child.name.begins_with("Square"):
			child.queue_free()
	squares.clear()
	
	# Create 8x8 grid of squares
	for row in range(8):
		var row_squares = []
		for col in range(8):
			var square = _create_square(row, col)
			add_child(square)
			row_squares.append(square)
		squares.append(row_squares)
	
	# Center the board
	position = Vector3(-3.5 * square_size, 0, -3.5 * square_size)

func _create_square(row: int, col: int) -> MeshInstance3D:
	var square = MeshInstance3D.new()
	square.name = "Square_%d_%d" % [row, col]
	
	# Create box mesh
	var mesh = BoxMesh.new()
	mesh.size = Vector3(square_size, board_height, square_size)
	square.mesh = mesh
	
	# Position the square
	square.position = Vector3(col * square_size, 0, row * square_size)
	
	# Alternate colors (chess board pattern)
	var is_light = (row + col) % 2 == 0
	if is_light:
		square.material_override = light_square_material
	else:
		square.material_override = dark_square_material
	
	return square

# Get world position for a board coordinate
func get_square_position(row: int, col: int) -> Vector3:
	var local_pos = Vector3(col * square_size, board_height / 2.0, row * square_size)
	return position + local_pos

# Get board coordinates from world position
func get_board_coords(world_pos: Vector3) -> Vector2i:
	var local_pos = world_pos - position
	var col = int(local_pos.x / square_size)
	var row = int(local_pos.z / square_size)
	return Vector2i(row, col)
