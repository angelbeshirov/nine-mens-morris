// Here constants for the classes in this module are defined.
// All constants are defined in an internal struct added by an extension
// for the particular class. This way we won't have some random
// structs defined at the global level thus polluting it.

extension Board {
    struct Constants 
    {
        // the neighbour indices of each node
        static let nodeNeighbours = [
            [1, 9],
            [0, 2, 4],
            [1, 14],
            [4, 10],
            [1, 3, 5, 7],
            [4, 13],
            [7, 11],
            [4, 6, 8],
            [7, 12],
            [0, 10, 21],
            [3, 9, 11, 18],
            [6, 10, 15],
            [8, 13, 17],
            [5, 12, 14, 20],
            [2, 13, 23],
            [11, 16],
            [15, 17, 19],
            [12, 16],
            [10, 19],
            [16, 18, 20, 22],
            [13, 19],
            [9, 22],
            [19, 21, 23],
            [14, 22]
        ]
        
        // the indices which can form a valid mills
        static let millIndices = [
            [0, 1, 2], // Horizontal mills
            [3, 4, 5],
            [6, 7, 8],
            [9, 10, 11],
            [12, 13, 14],
            [15, 16, 17],
            [18, 19, 20],
            [21, 22, 23],
            [0, 9, 21], // Vertical mills
            [3, 10, 18],
            [6, 11, 15],
            [1, 4, 7],
            [16, 19, 22],
            [8, 12, 17],
            [5, 13, 20],
            [2, 14, 23]
        ]

        // the index range for the board
        static let range = (0...23);

        // error descriptions for the user
        static let alreadyAssigned = "The piece you are trying to assign is already assigned."
        
        static let tryingToRemoveEmpty = "The piece you are trying to remove is empty."
        static let tryingToRemoveAssignedByMe = "The piece you are trying to remove is assigned by you, select one of your opponent's pieces."
        static let tryingToRemoveFromMillWhenAvailable = 
        "The piece you are trying to remove is part of a mill, while there are free pieces which are not part of any mills."
        
        static let tryingToMoveEmpty = "The piece you are trying to move is empty."
        static let tryingToMoveNotAssignedByMe = "The piece you are trying to move is not assigned by you."
        static let tryingToMoveToNotEmpty = "You are trying to move a piece to an already assigned index."
        static let tryingToMoveToNonAdjacent = "You are trying to move a piece to a non-adjacent index while you have more than 3 pieces left."
    }
}

extension ConsoleGame {
    struct Constants {
        // size of the board
        static let boardSize = 24
        static let screenSeparator = "------------------------------------------------------------"

        // console messages
        static let gameStarted = "The game has started!"
        static let invalidCoordinates = "The coordinates for piece assignment are outside the board!"
        static let tryAgain = "Please try again"

        static let startingMovingPhase = "All pieces have been placed, starting phase 2 - moving pieces"
        static let gameOver = "Game is over!"
    }
}