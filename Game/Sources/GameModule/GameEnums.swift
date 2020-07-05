import IOModule

// Maps the color of a player to the type of piece
// he will use when assigning pieces
extension PlayerColor {
    var pieceType: PieceType {
        switch self {
        case .black: return PieceType.black
        case .white: return PieceType.white
        }
    }
}

// The type of a piece used for assignment in the board.
public enum PieceType: String {
    case empty = "·"
    case white = "○"
    case black = "●"
}

// The states in which the game can be at each moment in time
public enum GameState {
    case placingPieces
    case movingPieces
    case flyingPieces
    case gameOver
}

// The player type. This enum can be extended to support vs AI later on
public enum PlayerType: String {
    case player1 = "Player 1"
    case player2 = "Player 2"
}