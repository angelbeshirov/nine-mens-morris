enum IOError: Error {
    case failedToGetInitialColors
    case failedToGetCoordinates
}

enum BoardError: Error { // can be changed to board error
    case indexOutOfRange
    case failedToAssignPiece(description: String)
    case failedToRemovePiece(description: String)
    case failedToMovePiece(description: String)
}

enum GameError: Error {
    case gameIsNotOver
}