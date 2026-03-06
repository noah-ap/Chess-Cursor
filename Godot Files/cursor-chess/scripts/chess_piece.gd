extends Node3D
class_name ChessPiece

enum PieceType { PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING }
enum PieceColor { WHITE, BLACK }

@export var piece_type: PieceType = PieceType.PAWN
@export var piece_color: PieceColor = PieceColor.WHITE

# Board position (0-7 for row and col)
var board_row: int = 0
var board_col: int = 0
var has_moved: bool = false

# Visual settings
var piece_material: ShaderMaterial

# Reference to the toon shader
var toon_shader: Shader

# Colors
const WHITE_COLOR = Color(0.70, 0.58, 0.45)  # Light tan wood
const BLACK_COLOR = Color(0.25, 0.25, 0.28)  # Dark grey (not pure black)

func _ready():
	# Load shader
	toon_shader = load("res://shaders/toon_piece.gdshader")
	
	# Create material
	_create_material()
	
	# Build the piece geometry
	_build_piece()

func _create_material():
	piece_material = ShaderMaterial.new()
	piece_material.shader = toon_shader
	
	# Set color based on piece color
	if piece_color == PieceColor.WHITE:
		piece_material.set_shader_parameter("albedo", WHITE_COLOR)
	else:
		piece_material.set_shader_parameter("albedo", BLACK_COLOR)
	
	# Toon shader settings
	piece_material.set_shader_parameter("cuts", 3)
	piece_material.set_shader_parameter("wrap", 0.1)
	piece_material.set_shader_parameter("use_specular", true)
	piece_material.set_shader_parameter("specular_strength", 0.5)
	piece_material.set_shader_parameter("specular_shininess", 16.0)

func _build_piece():
	# Clear existing geometry
	for child in get_children():
		child.queue_free()
	
	# Build based on piece type
	match piece_type:
		PieceType.PAWN:
			_build_pawn()
		PieceType.ROOK:
			_build_rook()
		PieceType.KNIGHT:
			_build_knight()
		PieceType.BISHOP:
			_build_bishop()
		PieceType.QUEEN:
			_build_queen()
		PieceType.KING:
			_build_king()

func _add_mesh(mesh: Mesh, pos: Vector3, scale_factor: Vector3 = Vector3.ONE) -> MeshInstance3D:
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = mesh
	mesh_instance.position = pos
	mesh_instance.scale = scale_factor
	mesh_instance.material_override = piece_material
	add_child(mesh_instance)
	return mesh_instance

func _build_pawn():
	# Base cylinder
	var base = CylinderMesh.new()
	base.top_radius = 0.25
	base.bottom_radius = 0.3
	base.height = 0.15
	_add_mesh(base, Vector3(0, 0.075, 0))
	
	# Body cylinder
	var body = CylinderMesh.new()
	body.top_radius = 0.15
	body.bottom_radius = 0.2
	body.height = 0.3
	_add_mesh(body, Vector3(0, 0.3, 0))
	
	# Head sphere
	var head = SphereMesh.new()
	head.radius = 0.15
	head.height = 0.3
	_add_mesh(head, Vector3(0, 0.55, 0))

func _build_rook():
	# Base
	var base = CylinderMesh.new()
	base.top_radius = 0.3
	base.bottom_radius = 0.35
	base.height = 0.15
	_add_mesh(base, Vector3(0, 0.075, 0))
	
	# Body
	var body = CylinderMesh.new()
	body.top_radius = 0.25
	body.bottom_radius = 0.28
	body.height = 0.5
	_add_mesh(body, Vector3(0, 0.4, 0))
	
	# Top (battlements represented by a box)
	var top = BoxMesh.new()
	top.size = Vector3(0.4, 0.15, 0.4)
	_add_mesh(top, Vector3(0, 0.725, 0))

func _build_knight():
	# Base
	var base = CylinderMesh.new()
	base.top_radius = 0.28
	base.bottom_radius = 0.32
	base.height = 0.15
	_add_mesh(base, Vector3(0, 0.075, 0))
	
	# Body
	var body = CylinderMesh.new()
	body.top_radius = 0.2
	body.bottom_radius = 0.25
	body.height = 0.35
	_add_mesh(body, Vector3(0, 0.325, 0))
	
	# Head (angled box for horse head)
	var head = BoxMesh.new()
	head.size = Vector3(0.2, 0.35, 0.25)
	var head_mesh = _add_mesh(head, Vector3(0.05, 0.6, 0))
	head_mesh.rotation_degrees = Vector3(0, 0, 15)

func _build_bishop():
	# Base
	var base = CylinderMesh.new()
	base.top_radius = 0.28
	base.bottom_radius = 0.32
	base.height = 0.15
	_add_mesh(base, Vector3(0, 0.075, 0))
	
	# Body
	var body = CylinderMesh.new()
	body.top_radius = 0.12
	body.bottom_radius = 0.22
	body.height = 0.5
	_add_mesh(body, Vector3(0, 0.4, 0))
	
	# Top (pointed)
	var top = CylinderMesh.new()
	top.top_radius = 0.02
	top.bottom_radius = 0.12
	top.height = 0.25
	_add_mesh(top, Vector3(0, 0.775, 0))
	
	# Ball on top
	var ball = SphereMesh.new()
	ball.radius = 0.05
	ball.height = 0.1
	_add_mesh(ball, Vector3(0, 0.92, 0))

func _build_queen():
	# Base
	var base = CylinderMesh.new()
	base.top_radius = 0.3
	base.bottom_radius = 0.35
	base.height = 0.15
	_add_mesh(base, Vector3(0, 0.075, 0))
	
	# Body
	var body = CylinderMesh.new()
	body.top_radius = 0.15
	body.bottom_radius = 0.25
	body.height = 0.6
	_add_mesh(body, Vector3(0, 0.45, 0))
	
	# Crown base
	var crown_base = CylinderMesh.new()
	crown_base.top_radius = 0.18
	crown_base.bottom_radius = 0.15
	crown_base.height = 0.15
	_add_mesh(crown_base, Vector3(0, 0.825, 0))
	
	# Crown ball
	var crown = SphereMesh.new()
	crown.radius = 0.1
	crown.height = 0.2
	_add_mesh(crown, Vector3(0, 0.97, 0))

func _build_king():
	# Base
	var base = CylinderMesh.new()
	base.top_radius = 0.32
	base.bottom_radius = 0.38
	base.height = 0.15
	_add_mesh(base, Vector3(0, 0.075, 0))
	
	# Body
	var body = CylinderMesh.new()
	body.top_radius = 0.18
	body.bottom_radius = 0.28
	body.height = 0.6
	_add_mesh(body, Vector3(0, 0.45, 0))
	
	# Crown base
	var crown_base = CylinderMesh.new()
	crown_base.top_radius = 0.2
	crown_base.bottom_radius = 0.18
	crown_base.height = 0.12
	_add_mesh(crown_base, Vector3(0, 0.81, 0))
	
	# Cross vertical
	var cross_v = BoxMesh.new()
	cross_v.size = Vector3(0.08, 0.25, 0.08)
	_add_mesh(cross_v, Vector3(0, 1.0, 0))
	
	# Cross horizontal
	var cross_h = BoxMesh.new()
	cross_h.size = Vector3(0.2, 0.08, 0.08)
	_add_mesh(cross_h, Vector3(0, 1.05, 0))

# Set board position
func set_board_position(row: int, col: int):
	board_row = row
	board_col = col

# Get board position
func get_board_position() -> Vector2i:
	return Vector2i(board_row, board_col)
