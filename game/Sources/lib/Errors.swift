import Foundation

enum IOError: Error {
    case FailedToGetInitialColors
    case FailedToGetCoordinates
}

enum InputError: Error { // can be changed to board error
    case InvalidPieceID
    case InvalidAssignPieceID
    case InvalidMovePieceID
    case InvalidRemovePieceID
    case InvalidRemovePieceID_freePieces // sth else?
    case InvalidMovePieceIDs_notAdjacent
}

enum GameErorr: Error {
    case InvalidGameState
}