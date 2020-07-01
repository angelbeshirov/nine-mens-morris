public class Player {
    var color: PlayerColor
    var board: Board
    // var initialPieces: Int
    var placedPieces: Int

    public init(color: PlayerColor, board: Board) {
        self.color = color
        self.board = board
        // self.initialPieces = 9
        self.placedPieces = 0
    }

    public func assign(index: Int) throws {
        try board.assign(index: index, color: self.color)
        self.placedPieces += 1
    }

    public func removePiece(index: Int) throws {
        guard let piece = board.getPieceAt(at: index) else {
            return
        }

        if color.pieceType != piece {
            try board.remove(index: index)
        }
    }

    public func movePiece(index1: Int, index2: Int) throws {
        
        guard let piece1 = board.getPieceAt(at: index1), let piece2 = board.getPieceAt(at: index2) else {
            return
        }

        if color.pieceType == piece1 {
            try board.move(from: index1, to: index2)
        }

        // TODO shouldnt we use only 1 marker?
    }

    public func hasPieces() -> Bool {
        return self.placedPieces < 9
    }

    public func getPieces() -> Int {
        return 9 - self.placedPieces
    }

    public func getPlacedPieces() -> Int {
        return self.placedPieces
    }
}
