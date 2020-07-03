public class Player {
    private var color: PlayerColor
    private var board: Board
    private var _placedPieces: Int
    private var _piecesToPlace: Int

    var hasPiecesToPlace: Bool {
        get {
            return _piecesToPlace > 0
        }
    }

    var placedPieces: Int {
        get {
            return _placedPieces
        }
    }

    var piecesToPlace: Int {
        get {
            return _piecesToPlace
        }
    }

    public init(color: PlayerColor, board: Board) {
        self.color = color
        self.board = board
        self._placedPieces = 0
        self._piecesToPlace = 9
    }

    public func assign(index: Int) throws -> Bool {
        let formedMill: Bool = try board.assign(index: index, color: self.color)
        self._placedPieces += 1
        self._piecesToPlace -= 1
        return formedMill
    }

    public func removePiece(index: Int) throws {
        try board.remove(index: index, pieceType: color.pieceType)
        self._placedPieces -= 1
    }

    public func movePiece(index1: Int, 
                          index2: Int, 
                          adjacentOnly: Bool = true) throws -> Bool {
        return try board.move(from: index1, 
                              to: index2, 
                              fromPieceType: color.pieceType, 
                              adjacentOnly: adjacentOnly)
    }
}
