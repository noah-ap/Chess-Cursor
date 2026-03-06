import java.util.Scanner;

public class UserInput 
{
    private Scanner input;

    public UserInput() 
    {
        input = new Scanner(System.in);
    }

    public Move getMove() 
    {
        System.out.println("Enter a move: ");

        String move = input.nextLine();

        String[] parts = move.split(" ");

        if (parts.length != 2)
        {
            System.out.print("Invalid Input");
            return null;
        }

        String at = parts[0];
        String to = parts[1];

        if (!at.matches("[a-h][1-8]") || !to.matches("[a-h][1-8]")) 
        {
            System.out.print("Invalid Input");
            return null;
        }

        char atFile = at.charAt(0);
        char atRank = at.charAt(1);

        char toFile = to.charAt(0);
        char toRank = to.charAt(1);

        int atCol = atFile - 'a';
        int atRow = 8 - (atRank - '0');
        
        int toCol = toFile - 'a';
        int toRow = 8 - (toRank - '0');

        if (!inBounds(atRow, atCol) || !inBounds(toRow, toCol)) 
        {
            System.out.print("Invalid Input");
            return null;
        }
    
        // Traverse 2DArray with rows first so rows and cols orders are reversed
        // Ex. String cords = atRow + " " + atCol + " " + toRow + " " + toCol;

        return new Move(atRow, atCol, toRow, toCol);
    }

    private boolean inBounds(int row, int col) 
    {
        return row >= 0 && row < 8 && col >= 0 && col < 8;
    }
}