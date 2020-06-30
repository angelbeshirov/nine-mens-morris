public enum Color: String {
    case black
    case white
}

public class Runner {

    public init() {
        // TODO initialize in a smarter way
    }

    public func start() {
        let ioUtil: IOUtil = IOUtil();
        let colors: (Color, Color) = ioUtil.getPlayerColors();

        let board = Board(size: 7);
        let player1: Player = Player(color: colors.0, board: board);
        let player2: Player = Player(color: colors.1, board: board);

        var player1Turn = true;

        board.visualize();

        while player1.hasPieces() || player2.hasPieces() {
            if player1Turn {
                print("Player 1 please enter coordinates to place a piece:");
                let coordinates: (Int) = ioUtil.getSingleCoordinates();
                player1.assign(index: coordinates);
                player1Turn = false;
                print("Player 1, you have \(player1.getPieces()) left");
            } else {
                print("Player 2 please enter coordinates to place a piece:");
                let coordinates: (Int) = ioUtil.getSingleCoordinates();
                player2.assign(index: coordinates);
                player1Turn = true;
                print("Player 2, you have \(player2.getPieces()) left");
            }

            board.visualize();
        }

        // phase 2 (adjacent positions only)

        while player1.getPlacedPieces() > 2 && player2.getPlacedPieces() > 2 {
            if player1Turn {
                print("Player 1 please enter coordinates to move a piece");
                let coordinates: (Int, Int) = ioUtil.getDoubleCoordinates();
                player1.movePiece(index1: coordinates.0, index2: coordinates.1);
                player1Turn = false;
            } else {
                print("Player 2 please enter coordinates to move a piece:");
                let coordinates: (Int, Int) = ioUtil.getDoubleCoordinates();
                player2.movePiece(index1: coordinates.0, index2: coordinates.1);
                player1Turn = true;
            }

            board.visualize();
        }
    }
}
