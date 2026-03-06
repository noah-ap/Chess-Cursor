public class Board 
{
    private String[][] layout;
    private Piece[][] pieces;

    private Color currentTurn = Color.WHITE;

    public Board()
    {
        layout = new String[][] {        
            {"BR", "BN", "BB", "BQ", "BK", "BB", "BN", "BR"},
            {"BP", "BP", "BP", "BP", "BP", "BP", "BP", "BP"},
            {"--", "--", "--", "--", "--", "--", "--", "--"},
            {"--", "--", "--", "--", "--", "--", "--", "--"},
            {"--", "--", "--", "--", "--", "--", "--", "--"},
            {"--", "--", "--", "--", "--", "--", "--", "--"},
            {"WP", "WP", "WP", "WP", "WP", "WP", "WP", "WP"},
            {"WR", "WN", "WB", "WQ", "WK", "WB", "WN", "WR"} 
            }; 

        pieces = new Piece[8][8];
        for(int r = 0; r < 8; r++)
            {
            for (int c = 0; c < 8; c++)
                {
                    Type type = Type.PAWN; 
                    Color color;

                    String cell = layout[r][c];

                    if (cell.equals("--"))
                    {
                        pieces[r][c] = null;
                        continue;
                    }

                    if (cell.charAt(0) == 'W') 
                    {
                        color = Color.WHITE;
                    }
                    else 
                    {
                        color = Color.BLACK;
                    }

                    switch (cell.charAt(1))
                    {
                        case 'K': type = Type.KING;     break;
                        case 'Q': type = Type.QUEEN;    break;
                        case 'R': type = Type.ROOK;     break;
                        case 'B': type = Type.BISHOP;   break;
                        case 'N': type = Type.KNIGHT;   break;   
                        case 'P': type = Type.PAWN;     break;  
                    }

                    pieces[r][c] = new Piece(color, type, r, c);
                }
            }
    }

    public void printBoard() 
    {
        for (int r = 0; r < 8; r++) 
            {

                System.out.print((8- r) + " ");

                for (int c = 0; c < 8; c++) 
                {

                    Piece pChar = pieces[r][c];
                    char colorChar = '-';
                    char typeChar = '-';

                    if (pChar != null)
                    {
                        switch (pChar.getColor())
                        {
                            case WHITE: colorChar = 'W'; break;
                            case BLACK: colorChar = 'B'; break;
                        }

                        switch (pChar.getType())
                        {
                            case KING:      typeChar = 'K'; break;
                            case QUEEN:     typeChar = 'Q'; break;
                            case ROOK:      typeChar = 'R'; break;
                            case BISHOP:    typeChar = 'B'; break;
                            case KNIGHT:    typeChar = 'N'; break;
                            case PAWN:      typeChar = 'P'; break;
                        }
                    }

                    System.out.printf("%c%c ", colorChar, typeChar); 
                }
                System.out.println();
            }

            System.out.print("  ");
            for (char file = 'a'; file <= 'h'; file++)
            {
                System.out.print(file + "  ");
            }
            System.out.println();
    }

    public Piece getPiece(int r, int c) { return pieces[r][c]; }
    public Color getCurrentTurn()       { return currentTurn; }

    // Move Application and Finialization

    public void applyMove(Move move, MoveContext ctx) 
    {
        // Update Board Array
        pieces[ctx.toRow][ctx.toCol] = ctx.movingPiece;
        pieces[ctx.atRow][ctx.atCol] = null;
            
        // Update cords of Piece
        ctx.movingPiece.setRowCol(ctx.toRow, ctx.toCol);
    }

    public void undoMove(Move move, MoveContext ctx)
    {
        // Restore Board Array
        pieces[ctx.atRow][ctx.atCol] = ctx.movingPiece;
        pieces[ctx.toRow][ctx.toCol] = ctx.targetPiece;
        
        // Update cords of Pieces
        ctx.movingPiece.setRowCol(ctx.atRow, ctx.atCol);

        if (ctx.targetPiece != null)
        {
            ctx.targetPiece.setRowCol(ctx.toRow, ctx.toCol);
        }
    }

    public void finalizeMove(Move move)
    {
        MoveContext ctx = new MoveContext(this, move);

        // Check if move is legal
        if (!isLegalMove(ctx))
        {
            System.out.println("Move NOT Legal!");
            return;
        }

        applyMove(move, ctx);

        // Check if current players king is in check
        if (isKingInCheck(currentTurn))
        {
            undoMove(move, ctx);
            System.out.println("Your King is in CHECK!");
            return;
        }

        // Finalize move - piece has moved set to true - change turn
        ctx.movingPiece.setHasMoved(true);
        currentTurn = (currentTurn == Color.WHITE) ? Color.BLACK : Color.WHITE;

        System.out.println();

        if (isWhiteInCheck() == true)
        {
            System.out.println("White is in check!");
        }

        if (isBlackInCheck() == true)
        {
            System.out.println("Black is in check!");
        }

        System.out.println( "Moved " + ctx.movingPiece.getColor() + " " + ctx.movingPiece.getType() +
                " from (" + ctx.atRow + "," + ctx.atCol + ") to (" + ctx.toRow + "," + ctx.toCol + ")");

        System.out.println("It's " + currentTurn + "'s turn.");
    }

    // Move legality 

    public boolean isInsideBoard(MoveContext ctx)
    {
        return isInside(ctx.atRow, ctx.atCol) && isInside(ctx.toRow, ctx.toCol);
    }
    
    private boolean isInside(int r, int c)
    {
        return r >= 0 && r < 8 && c >= 0 && c < 8;
    }

    public boolean isCorrectTurn(MoveContext ctx)
    {
        if (ctx.movingColor != currentTurn)
        {
            System.out.println("It's " + currentTurn + "'s turn!");
            return false;
        }
        return true;
    }

    public boolean hasMovingPiece(MoveContext ctx)
    {
        return ctx.movingPiece != null;
    }

    public boolean isTargetAllowed(MoveContext ctx)
    {
        if (ctx.targetPiece != null)
        {
            if (ctx.movingColor == ctx.targetColor)
            {
                System.out.println("Target not allowed!");
                return false;
            }
        }
        return true;
    }

    public boolean isPieceMoveLegal(MoveContext ctx)
    {
        switch (ctx.movingType)
        {
            case KING:

                // Add Castling

                if (Math.abs(ctx.deltaRow) <= 1 && Math.abs(ctx.deltaCol) <= 1) 
                    { return true; } 
                break;

            case QUEEN:
                
                if ( (Math.abs(ctx.deltaRow) == Math.abs(ctx.deltaCol)) || ((ctx.deltaRow == 0) ^ (ctx.deltaCol == 0)) )
                    { return true; }
                break;

            case ROOK:

                if ((ctx.deltaRow == 0) ^ (ctx.deltaCol == 0))
                    { return true; }
                break;

            case BISHOP:

                if (Math.abs(ctx.deltaRow) == Math.abs(ctx.deltaCol))
                    { return true; }
                break;

            case KNIGHT:

                if ( ((Math.abs(ctx.deltaRow) == 2) && (Math.abs(ctx.deltaCol) == 1)) || ((Math.abs(ctx.deltaRow) == 1) && (Math.abs(ctx.deltaCol) == 2)) )
                    { return true; }
                break;

            case PAWN:

                if (ctx.deltaRow == ctx.pawnDirection && Math.abs(ctx.deltaCol) == 0) 
                    {return true;}

                // Move 2 Squares Foward
                if ((ctx.deltaRow == (ctx.pawnDirection * 2) && Math.abs(ctx.deltaCol) == 0) && (!ctx.hadMovedBefore)) 
                    {return true;}

                // Capture only legal if piece at target square
                if ( ctx.deltaRow == ctx.pawnDirection && Math.abs(ctx.deltaCol) == 1 && (ctx.targetPiece != null) ) 
                    {return true;}
                break;
            
            default:
                break;
        } 

        return false;
    }

    public boolean isPathClear(MoveContext ctx)
    {
        int currentRow = ctx.atRow + ctx.stepRow;
        int currentCol = ctx.atCol + ctx.stepCol;

        if (ctx.movingType == Type.QUEEN || ctx.movingType == Type.ROOK || ctx.movingType == Type.BISHOP)
        {
            while (currentRow != ctx.toRow || currentCol != ctx.toCol)
            {
                if (pieces[currentRow][currentCol] != null)
                {
                    System.out.println("Path blocked!");
                    return false; 
                }

                currentRow += ctx.stepRow;
                currentCol += ctx.stepCol;
            }
        }
        return true;
    }

    public boolean isLegalMove(MoveContext ctx) 
    {
        if (!isInsideBoard(ctx)) return false;
        if (!hasMovingPiece(ctx)) return false;
        if (!isCorrectTurn(ctx)) return false;
        if (!isTargetAllowed(ctx)) return false;
        if (!isPieceMoveLegal(ctx)) return false;
        if (!isPathClear(ctx)) return false;

        return true;
    }

    // King Safety

    public Square getKingSquare(Color color)
    {
        for (int r = 0; r < 8; r++) 
            {
                for (int c = 0; c < 8; c++) 
                {
                    Piece p = pieces[r][c];

                    if (p != null && p.getType() == Type.KING && p.getColor() == color)
                    {
                        return new Square(r, c);
                    }
                }
            }
        return null;
    }

    private boolean rayAttacks(int r, int c, int targetRow, int targetCol)
    {
        int stepRow = Integer.compare(targetRow, r); // (target > r) 1, (target = r) 0, (target < r) -1
        int stepCol = Integer.compare(targetCol, c);

        int currentRow = r + stepRow;
        int currentCol = c + stepCol;

        while (currentRow >= 0 && currentRow < 8 && currentCol >= 0 && currentCol < 8)
        {
            if (currentRow == targetRow && currentCol == targetCol)     return true;  // target reeached
            if (pieces[currentRow][currentCol] != null)                 return false; // blocked by a piece

            currentRow += stepRow;
            currentCol += stepCol;
        }

        return false; // didn't ever hit the target while scanning through the board
    }

    public boolean isSquareAttacked(Square square, Color color)
    {
        int targetRow = square.getRow();
        int targetCol = square.getCol();

        for (int r = 0; r < 8; r++) {
            for (int c = 0; c < 8; c++) {
                Piece p = pieces[r][c];

                if (p == null)               continue; // empty square
                if (p.getColor() == color)   continue; // same color as target (king)

                int deltaRow = targetRow - r;
                int deltaCol = targetCol - c;
                    
                switch (p.getType()) 
                {
                    case KING:
                        if (Math.abs(deltaRow) <= 1 && Math.abs(deltaCol) <= 1) 
                            return true;
                        break;

                    case QUEEN:
                        if (deltaRow == 0 || deltaCol == 0 || Math.abs(deltaRow) == Math.abs(deltaCol))
                        {
                            if (rayAttacks(r, c, targetRow, targetCol))
                                return true;
                        }
                        break;

                    case BISHOP:
                        if (Math.abs(deltaRow) == Math.abs(deltaCol))
                        {
                            if (rayAttacks(r, c, targetRow, targetCol))
                                return true;
                        }
                        break;

                    case KNIGHT:
                        if ( ((Math.abs(targetRow - r) == 2) && (Math.abs(targetCol - c) == 1)) || ((Math.abs(targetRow - r) == 1) && (Math.abs(targetCol - c) == 2)) )
                            return true;
                        break;

                    case PAWN:
                        int pawnDir = (p.getColor() == Color.WHITE) ? -1 : 1; // pawns attack foward direction
                        if (deltaRow == pawnDir && Math.abs(deltaCol) == 1)
                            return true;
                        break;
                }
            }
            
        }

        return false; // no attacks on target (king)
    }

    public boolean isKingInCheck(Color kingColor) 
    {
        Square kingSquare = getKingSquare(kingColor);
        return isSquareAttacked(kingSquare, kingColor);
    }

    public boolean isWhiteInCheck() { return isKingInCheck(Color.WHITE); }

    public boolean isBlackInCheck() { return isKingInCheck(Color.BLACK); }
}
