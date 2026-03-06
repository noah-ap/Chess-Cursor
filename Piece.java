public class Piece {
    private Color color;
    private Type type;
    private int row;
    private int col;

    private boolean hasMoved;

    public Piece(Color color, Type type, int row, int col)
    {
        this.color = color;
        this.type = type;
        this.row = row;
        this.col = col;
        this.hasMoved = false;
    }

    public Color getColor() {return color;}
    public Type getType() {return type;}
    public int getRow() {return row;}
    public int getCol() {return col;}

    public boolean hasMoved() {return hasMoved;}

    public void setColor(Color color)
    {
        this.color = color;
    }

    public void setType(Type type)
    {
        this.type = type;
    }

    public void setRowCol(int row, int col)
    {
        this.row = row;
        this.col = col;
    }

    public void setHasMoved(boolean hasMoved)
    {
        this.hasMoved = hasMoved;
    }
}