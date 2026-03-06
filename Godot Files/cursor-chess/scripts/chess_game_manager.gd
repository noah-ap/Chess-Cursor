extends Node3D

# References
@export var chess_board: Node3D
var pieces: Array = []  # 2D array of pieces [row][col]

# Piece scenes (we'll create them dynamically)
var piece_script: Script

func _ready():
	# Load piece script
	piece_script = load("res://scripts/chess_piece.gd")
	
	# Initialize pieces array (8x8)
	for row in range(8):
		var row_array = []
		for col in range(8):
			row_array.append(null)
		pieces.append(row_array)
	
	# Setup the game
	_setup_starting_position()

func _setup_starting_position():
	# Clear existing pieces
	for child in get_children():
		if child.has_method("get_board_position"):
			child.queue_free()
	
	# Reset pieces array
	for row in range(8):
		for col in range(8):
			pieces[row][col] = null
	
	# Place white pieces (rows 6 and 7 in array = ranks 1 and 2 on board)
	_place_piece(7, 0, ChessPiece.PieceType.ROOK, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 1, ChessPiece.PieceType.KNIGHT, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 2, ChessPiece.PieceType.BISHOP, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 3, ChessPiece.PieceType.QUEEN, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 4, ChessPiece.PieceType.KING, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 5, ChessPiece.PieceType.BISHOP, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 6, ChessPiece.PieceType.KNIGHT, ChessPiece.PieceColor.WHITE)
	_place_piece(7, 7, ChessPiece.PieceType.ROOK, ChessPiece.PieceColor.WHITE)
	
	# White pawns (row 6 = rank 2)
	for col in range(8):
		_place_piece(6, col, ChessPiece.PieceType.PAWN, ChessPiece.PieceColor.WHITE)
	
	# Place black pieces (rows 0 and 1 in array = ranks 8 and 7 on board)
	_place_piece(0, 0, ChessPiece.PieceType.ROOK, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 1, ChessPiece.PieceType.KNIGHT, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 2, ChessPiece.PieceType.BISHOP, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 3, ChessPiece.PieceType.QUEEN, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 4, ChessPiece.PieceType.KING, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 5, ChessPiece.PieceType.BISHOP, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 6, ChessPiece.PieceType.KNIGHT, ChessPiece.PieceColor.BLACK)
	_place_piece(0, 7, ChessPiece.PieceType.ROOK, ChessPiece.PieceColor.BLACK)
	
	# Black pawns (row 1 = rank 7)
	for col in range(8):
		_place_piece(1, col, ChessPiece.PieceType.PAWN, ChessPiece.PieceColor.BLACK)

func _place_piece(row: int, col: int, type: ChessPiece.PieceType, color: ChessPiece.PieceColor):
	# Create piece node
	var piece = Node3D.new()
	piece.set_script(piece_script)
	piece.piece_type = type
	piece.piece_color = color
	piece.set_board_position(row, col)
	
	# Add to scene first (so _ready runs)
	add_child(piece)
	
	# Position the piece on the board
	if chess_board:
		var world_pos = chess_board.get_square_position(row, col)
		piece.position = world_pos + Vector3(0, 0.05, 0)  # Slightly above board
	else:
		# Fallback positioning if no board reference
		piece.position = Vector3(col, 0.15, row)
	
	# Store reference
	pieces[row][col] = piece

# Get piece at position
func get_piece_at(row: int, col: int) -> ChessPiece:
	if row < 0 or row > 7 or col < 0 or col > 7:
		return null
	return pieces[row][col]

# Move piece from one position to another
func move_piece(from_row: int, from_col: int, to_row: int, to_col: int) -> bool:
	var piece = pieces[from_row][from_col]
	if piece == null:
		return false
	
	# Remove any piece at destination (capture)
	var target = pieces[to_row][to_col]
	if target != null:
		target.queue_free()
	
	# Update array
	pieces[from_row][from_col] = null
	pieces[to_row][to_col] = piece
	
	# Update piece position
	piece.set_board_position(to_row, to_col)
	piece.has_moved = true
	
	# Animate or set position
	if chess_board:
		var world_pos = chess_board.get_square_position(to_row, to_col)
		piece.position = world_pos + Vector3(0, 0.05, 0)
	else:
		piece.position = Vector3(to_col, 0.15, to_row)
	
	return true

# Reset to starting position
func reset_game():
	_setup_starting_position()
