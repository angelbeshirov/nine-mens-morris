import IOModule

// Object representation of a player.
public class Player {

    // the color which this player uses to mark the pieces which he has placed
    private var color: PlayerColor

    // the game board
    private var board: Board

    // the number of placed pieces on the board
    private var _placedPieces: Int

    // the number of initial pieces which every placer has
    private var _piecesToPlace: Int

    public init(color: PlayerColor, board: Board) {
        self.color = color
        self.board = board
        self._placedPieces = 0
        self._piecesToPlace = 9
    }
}

// computable properties
extension Player {
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
}

// Functions for assigning, removing and moving pieces. All errors thrown 
// by the board are being propagated to the caller for handling.
extension Player {

    // assigns a piece on the board by using the color of the player
    public func assign(index: Int) throws -> Bool {
        let formedMill: Bool = try board.assign(index: index, color: self.color)
        self._placedPieces += 1
        self._piecesToPlace -= 1
        return formedMill
    }

    // removes a piece from the board
    public func removePiece(index: Int) throws {
        try board.remove(index: index, pieceType: color.pieceType)
        self._placedPieces -= 1
    }

    // moves a piece on the board
    public func movePiece(index1: Int, 
                          index2: Int, 
                          adjacentOnly: Bool = true) throws -> Bool {
        return try board.move(from: index1, 
                              to: index2, 
                              fromPieceType: color.pieceType, 
                              adjacentOnly: adjacentOnly)
    }
}
