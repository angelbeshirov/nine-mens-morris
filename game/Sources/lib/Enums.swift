// TODO add closures - done
// add how many pieces every player has after a piece has been removed - done
// change to more computable properties - done
// improve error handling
// add interfaces
// add external package
// separate to more than 1 internal package
// add tests
// add documentation
// fix the readme in github
// consider adding a validator?
// investigate about the IOUtil returning nil, is it needed to add all these errors for EOF???
// separate into extensions?
// look more into whether the Board class can be improved

public enum PlayerColor: String {
    case black
    case white

    var pieceType: PieceType {
        switch self {
        case .black: return PieceType.black
        case .white: return PieceType.white
        }
    }
}

public enum GameState {
    case placingPieces
    case movingPieces
    case flyingPieces
    case gameOver
    case undefined
}

// this can be extended to support vs computer
public enum PlayerType: String {
    case player1 = "Player 1"
    case player2 = "Player 2"
}

public enum PieceType: String {
    case empty = "·"
    case white = "○"
    case black = "●"
}