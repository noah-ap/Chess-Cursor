public class Chess3 
{
    public static void main(String[] args) 
    {
        Board board = new Board();
        UserInput userMove = new UserInput();

        board.printBoard();

        boolean checkMate = false;

        while (checkMate == false)
        {
            Move move = userMove.getMove();

            if (move != null)
            {
            board.finalizeMove(move);
            board.printBoard();
            }
        }
    }    
}   




    
