public class Player {
    var color: Color;
    var board: Board;
    // var initialPieces: Int;
    var placedPieces: Int;

    public init(color: Color, board: Board) {
        self.color = color;
        self.board = board;
        // self.initialPieces = 9;
        self.placedPieces = 0;
    }

    public func assign(index: Int) {
        board.assign(index: index, color: self.color)
        // self.initialPieces -= 1;
        self.placedPieces += 1;
    }

    public func removePiece(index: Int) {

        guard let piece = board.getPieceAt(at: index) else {
            return;
        }

        let pieceMarker: Piece;

        if color == Color.black {
            pieceMarker = Piece.white;
        } else {
            pieceMarker = Piece.black;
        }

        if pieceMarker == piece {
            board.remove(index: index);
        }
    }

    public func movePiece(index1: Int, index2: Int) {
        board.move(from: index1, to: index2);
    }

    public func hasPieces() -> Bool {
        return self.placedPieces < 9
    }

    public func getPieces() -> Int {
        return 9 - self.placedPieces;
    }

    public func getPlacedPieces() -> Int {
        return self.placedPieces;
    }
}
