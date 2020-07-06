import IOModule

// The player protocol which every player object should implement used in some game implementation.
// By abstracting this class behind a protocol, we allow different type of users to be created and
// used in the game implementation. One example can be 2 game modes:
// 1. human player vs human player
// 2. human player vs AI
public protocol Player {
    
    // checks whether the player has any pieces left to place
    var hasPiecesToPlace: Bool { get }

    // returns the number of placed pieces by the player
    var placedPieces: Int { get }

    // returns the number of pieces left to place by the player
    var piecesToPlace: Int { get }

    // Assigns a piece on the board
    func assignPiece(index: Int) throws -> Bool

    // Removes a piece from the board.
    func removePiece(index: Int) throws

    // Moves a piece on the board from index1 to index2. If the adjacentOnly 
    // flag is true the indices must be adjacent.
    func movePiece(index1: Int, index2: Int, adjacentOnly: Bool) throws -> Bool
}

// Object representation of a human player.
public class HumanPlayer: Player {

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
extension HumanPlayer {
    public var hasPiecesToPlace: Bool {
        get {
            return _piecesToPlace > 0
        }
    }

    public var placedPieces: Int {
        get {
            return _placedPieces
        }
    }

    public var piecesToPlace: Int {
        get {
            return _piecesToPlace
        }
    }
}

// Functions for assigning, removing and moving pieces. All errors thrown 
// by the board are being propagated to the caller for handling.
extension HumanPlayer {

    // assigns a piece on the board by using the color of the player
    public func assignPiece(index: Int) throws -> Bool {
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
                          adjacentOnly: Bool) throws -> Bool {
        return try board.move(from: index1, 
                              to: index2, 
                              fromPieceType: color.pieceType, 
                              adjacentOnly: adjacentOnly)
    }
}
