public class Player {
    private var color: PlayerColor
    private var board: Board
    private var _placedPieces: Int

    var hasPieces: Bool {
        get {
            return _placedPieces < 9
        }
    }

    var placedPieces: Int {
        get {
            return _placedPieces
        }
    }

    var piecesToPlace: Int {
        get {
            return 9 - _placedPieces
        }
    }


    public init(color: PlayerColor, board: Board) {
        self.color = color
        self.board = board
        self._placedPieces = 0
    }

    public func assign(index: Int) throws -> Bool {
        let formedMill: Bool = try board.assign(index: index, color: self.color)
        self._placedPieces += 1
        return formedMill
    }

    public func removePiece(index: Int) throws {
        // guard let piece = board.getPieceAt(at: index) else {
        //     return
        // }
        try board.remove(index: index, opponentPieceType: getOpponentPieceType())

        // if color.pieceType != piece {
        //     try board.remove(index: index)
        // } else {
        //     throw InputError.InvalidRemovePieceID
        // }
    }

    public func movePiece(index1: Int, index2: Int) throws -> Bool { // TODO this is not very good, maybe throw only from board???
        guard let piece1 = board.getPieceAt(at: index1) else {
            throw InputError.InvalidPieceID
        }

        if color.pieceType == piece1 {
            return try board.move(from: index1, to: index2)
        } else {
            throw InputError.InvalidMovePieceID
        }
    }

    private func getOpponentPieceType() -> PieceType {
        if color.pieceType == PieceType.black {
            return PieceType.white
        }

        return PieceType.black
    }
}
