import IOModule

// The player protocol which every player object should implement used in some game implementation.
// By abstracting this class with a protocol, we allow different type of users to be created and
// used in the game implementation. One example can be 2 game modes:
// 1. human player vs human player
// 2. human player vs AI - the game class can be extended with 1 more phase - mode selection
public protocol Player {
    
    // checks whether the player has any pieces left to place
    var hasPiecesToPlace: Bool { get }

    // returns the number of placed pieces by the player
    var placedPieces: Int { get }

    // returns the number of pieces left to place by the player
    var piecesToPlace: Int { get }

    // assigns a piece on the board
    func assignPiece(index: Int) throws -> Bool

    // removes a piece from the board
    func removePiece(index: Int) throws

    // moves a piece on the board from index1 to index2 
    func movePiece(index1: Int, index2: Int) throws -> Bool

    // predicate to check whether the player is able to make a valid move
    func hasValidMoves() -> Bool
}

// Object representation of a human player.
public class HumanPlayer: Player {

    // the color which this player uses to mark the pieces which he has placed
    private var color: PlayerColor

    // the game board
    private var board: Board

    // the number of placed pieces on the board
    private var _placedPieces: Int

    // the number of initial pieces which every player has to place
    private var _piecesToPlace: Int

    // initializer
    public init(color: PlayerColor, board: Board) {
        self.color = color
        self.board = board
        self._placedPieces = 0
        self._piecesToPlace = 9
    }
}

// computable properties
extension HumanPlayer {

    // returns true if the player has any pieces left to place
    // and false otherwise
    public var hasPiecesToPlace: Bool {
        get {
            return _piecesToPlace > 0
        }
    }

    // returns the number of placed pieces by the player
    public var placedPieces: Int {
        get {
            return _placedPieces
        }
    }

    // returns the number of pieces left to be placed by the player
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
        let completedMill: Bool = try board.assign(index: index, color: self.color)
        self._placedPieces += 1
        self._piecesToPlace -= 1
        return completedMill
    }

    // removes a piece from the board
    public func removePiece(index: Int) throws {
        try board.remove(index: index, pieceType: color.pieceType)
        self._placedPieces -= 1
    }

    // Moves a piece on the board. If the player has 3 pieces left then the
    // selected indices can be non-adjacent, otherwise they must be adjacent.
    public func movePiece(index1: Int, 
                          index2: Int) throws -> Bool {
        var adjacentOnly = true
        if !hasPiecesToPlace && placedPieces == 3 {
            adjacentOnly = false
        }
        return try board.move(from: index1, 
                              to: index2, 
                              playerPieceType: color.pieceType, 
                              adjacentOnly: adjacentOnly)
    }
}

extension HumanPlayer {

    // function to check whether the player has any valid moves.
    public func hasValidMoves() -> Bool {
        // player can fly or the player still has pieces left to place
        if placedPieces == 3 || piecesToPlace > 0 {
            return true
        }

        // if the piece type is blocked no valid moves exist, the negation is returned
        return !board.checkIfPieceTypeIsBlocked(pieceType: color.pieceType) 
    }
}
