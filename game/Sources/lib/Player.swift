public class Player {
    var color: Color;
    var board: Board;
    // var initialPieces: Int;
    var placedPieces: Int;
    var oppositeMarker: Piece;

    public init(color: Color, board: Board) {
        self.color = color;
        self.board = board;
        // self.initialPieces = 9;
        self.placedPieces = 0;

        if self.color == Color.black {
            self.oppositeMarker = Piece.white;
        } else {
            self.oppositeMarker = Piece.black;
        }
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

        if self.oppositeMarker == piece {
            board.remove(index: index);
        }
    }

    public func movePiece(index1: Int, index2: Int) {
        
        guard let piece1 = board.getPieceAt(at: index1), let piece2 = board.getPieceAt(at: index2) else {
            return;
        }

        if self.oppositeMarker != piece1 {
            board.move(from: index1, to: index2);
        }

        // TODO shouldnt we use only 1 marker?
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
