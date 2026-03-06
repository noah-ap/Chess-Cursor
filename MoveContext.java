public class MoveContext {
    public final Move move;

    public final Piece movingPiece;
    public final Piece targetPiece;

    public final int atRow, atCol, toRow, toCol;
    public final int deltaRow, deltaCol;
    public final int stepRow, stepCol;

    public final Color movingColor, targetColor;
    public final Type movingType, targetType;

    public final int pawnDirection;

    public boolean hadMovedBefore;

    public MoveContext(Board board, Move move)
    {
        this.move = move;

        this.atRow = move.getAtRow();
        this.atCol = move.getAtCol();
        this.toRow = move.getToRow();
        this.toCol = move.getToCol();
        
        this.deltaRow = toRow - atRow;
        this.deltaCol = toCol - atCol;

        this.stepRow = Integer.signum(deltaRow);  
        this.stepCol = Integer.signum(deltaCol); 

        this.movingPiece = board.getPiece(atRow, atCol);
        this.targetPiece = board.getPiece(toRow, toCol);

        this.movingColor = (movingPiece != null) ? movingPiece.getColor() : null;
        this.movingType  = (movingPiece != null) ? movingPiece.getType()  : null;

        this.targetColor = (targetPiece != null) ? targetPiece.getColor() : null;
        this.targetType  = (targetPiece != null) ? targetPiece.getType()  : null;

        this.pawnDirection = (movingColor == Color.WHITE) ? -1 : 1;
        this.hadMovedBefore = (movingPiece != null) && movingPiece.hasMoved();
    }
}