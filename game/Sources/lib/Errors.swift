import Foundation

enum IOError: Error {
    case FailedToGetInitialColors
    case FailedToGetCoordinates
}

enum InputError: Error {
    case InvalidPieceID
    case InvalidMovePieceIDs
    case InvalidRemoveID
}