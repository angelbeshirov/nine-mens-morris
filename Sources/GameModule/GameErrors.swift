// The board errors for invalid operations
enum BoardError: Error {
    case indexOutOfRange
    case failedToAssignPiece(description: String)
    case failedToRemovePiece(description: String)
    case failedToMovePiece(description: String)
}

// Game errors
enum GameError: Error {
    case wrongGameState
}