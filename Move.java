public class Move {
    private int atRow;
    private int atCol;
    private int toRow;
    private int toCol;

    public Move(int atRow, int atCol, int toRow, int toCol)
    {
        this.atRow = atRow;
        this.atCol = atCol;
        this.toRow = toRow;
        this.toCol = toCol;
    }

    public int getAtRow() { return atRow; } 
    public int getAtCol() { return atCol; }
    public int getToRow() { return toRow; }
    public int getToCol() { return toCol; }
    
}