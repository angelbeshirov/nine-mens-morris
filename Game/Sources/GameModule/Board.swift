import IOModule

// This class encapsulates the logic for doing operations
// on the game board.
public class Board {

    // the number of intersaction on the board
    private var size: Int

    // the class responsible for handling the visualizing the outputs from the game
    private var outputHandler: OutputHandler

    // the array of pieces, the size of this array should be the same as the size
    private var pieces: [PieceType]

    // the array of mills which can be completed on this board
    private var mills: [Mill]

    // the public initializer with 2 parameters: the size of
    // the board and the outputhandler
    public init(_size: Int, outputHandler: OutputHandler) {
        self.size = _size
        self.outputHandler = outputHandler
        self.pieces = Array(repeating: PieceType.empty, count: _size)
        self.mills = [Mill]()

        for element in Constants.millIndices {
            mills.append(Mill(indices: element))
        }
    }
}

extension Board {

    // Assignes a color to a particular piece on the table which is accessed using 
    // it's index. If the index is invalid BoardError.indexOutOfRange is thrown, 
    // if the piece has already been assigned BoardError.failedToAssignPiece is thrown 
    // with appropriate description for the error. If after assignment a mill has been
    // completed the method returns true, otherwise it returns false.
    public func assign(index: Int, color: PlayerColor) throws -> Bool {
        guard Constants.range.contains(index) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[index] == PieceType.empty else {
            throw BoardError.failedToAssignPiece(description: Constants.alreadyAssigned)
        }

        // get the mills before update
        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndEmpty(index: index) }
        let millsCompleted = millsForIndex.map{ $0.isCompleted }

        // update
        pieces[index] = color.pieceType

        // get the mills after update
        millsForIndex.forEach { (mill) in mill.assign(index: index, pieceType: color.pieceType)}
        let millsCompletedAfterAssignment = millsForIndex.map{ $0.isCompleted }

        return millsCompleted != millsCompletedAfterAssignment
    }
}

extension Board {

    // Removes an assigned piece from the board by setting the type of the piece to the 
    // initial empty type. If the index is invalid BoardError.indexOutOfRange will be thrown,
    // if the piece is empty (not assigned by anyone or already removed) or if the piece has 
    // not been assigned by the player who is trying to remove the piece BoardError.failedToRemovePiece 
    // error will be thrown with appropriate description with information about the error.
    public func remove(index: Int, pieceType: PieceType) throws {
        guard Constants.range.contains(index) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[index] != PieceType.empty else {
            throw BoardError.failedToRemovePiece(description: Constants.tryingToRemoveEmpty)
        }

        guard pieces[index] == pieceType else {
            throw BoardError.failedToRemovePiece(description: Constants.tryingToRemoveAssignedByMe)
        }

        let partOfCompetedMill = mills.filter { (mill) in mill.hasIndex(index: index) && mill.isCompleted }.count > 0

        if partOfCompetedMill {
            let opponenetIndices: [Int] = pieces.enumerated()
                .filter { (idx, type) in type == pieceType }
                .map { (idx, type) in return idx }

            var allAreMills: Bool = true

            for idx in opponenetIndices {
                // if there are 0 completed mills for particular index then this index is 
                // not part of a completed mill otherwise it is
                if (mills.filter { (mill) in mill.hasIndex(index: idx) && mill.isCompleted }.count == 0) {
                    allAreMills = false
                    break
                }
            }

            // this checks whether all opponenet's pieces are part of completed mills
            if !allAreMills {
                throw BoardError.failedToRemovePiece(description: Constants.tryingToRemoveFromMillWhenAvailable)
            }
        }

        doRemove(index: index)
    }
}

extension Board {

    // Moves an assigned piece from one index to another unassigned index thus the 
    // initial piece at the first index will be assigned to the empty type and the empty 
    // piece on the second index will be assigned the type of the initial piece. 
    // If the adjacentOnly flag is true it will also check whether the indices are 
    // adjacent and if they are not BoardError.failedToMovePiece will be thrown.
    // If any of the two indices passed (from or to) are invalid BoardError.indexOutOfRange 
    // will be thrown, if the piece which you are trying to move is empty or not assigned 
    // by the player who is trying to move the piece or the destination piece is not empty 
    // BoardError.failedToMovePiece will be thrown with appropriate description. 
    // If after moving a piece a mill has been completed the method returns true, 
    // otherwise it returns false.
    public func move(from: Int, to: Int, fromPieceType: PieceType, adjacentOnly: Bool) throws -> Bool {
        guard Constants.range.contains(from) && Constants.range.contains(to) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[from] != PieceType.empty else {
            throw BoardError.failedToMovePiece(description: Constants.tryingToMoveEmpty)
        }

        guard pieces[from] == fromPieceType else {
            throw BoardError.failedToMovePiece(description: Constants.tryingToMoveNotAssignedByMe)
        }

        guard pieces[to] == PieceType.empty else {
            throw BoardError.failedToMovePiece(description: Constants.tryingToMoveToNotEmpty)
        }

        // This guard is logical implication adjOnly->isAdjecent
        // meaning if adjOnly is true then isAdjacent must also be true. Truth table is below
        // adjOnly isAdjecent
        // true true -> true
        // true false -> false
        // false true -> true
        // false false -> true
        guard !adjacentOnly || isAdjacent(element: from, adjacentTo: to) else {
            // if the index is not adjacent to the initial index 
            // (for phase 2 and phase 3 for the player with more than 3 pieces)
            throw BoardError.failedToMovePiece(description: Constants.tryingToMoveToNonAdjacent)
        }

        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndEmpty(index: to) }
        let millsCompleted = millsForIndex.map{ $0.isCompleted }

        pieces[to] = pieces[from]
        doRemove(index: from)

        millsForIndex.forEach { (mill) in mill.assign(index: to, pieceType: pieces[to])}
        let millsCompletedAfterAssignment = millsForIndex.map{ $0.isCompleted }

        return millsCompleted != millsCompletedAfterAssignment
    }
}

extension Board {

    // Visualizes the board to the user, using the outputHandler.
    public func visualize() {
        let boardTextVisualization = 
        "    A   B   C   D   E   F   G\n" +
        "1   \(pieces[0].rawValue)-----------\(pieces[1].rawValue)-----------\(pieces[2].rawValue)\n" + 
        "    |           |           |\n" +
        "2   |   \(pieces[3].rawValue)-------\(pieces[4].rawValue)-------\(pieces[5].rawValue)   |\n" +
        "    |   |       |       |   |\n" +
        "3   |   |   \(pieces[6].rawValue)---\(pieces[7].rawValue)---\(pieces[8].rawValue)   |   |\n" +
        "    |   |   |       |   |   |\n" +
        "4   \(pieces[9].rawValue)---\(pieces[10].rawValue)---\(pieces[11].rawValue)    " +
        "   \(pieces[12].rawValue)---\(pieces[13].rawValue)---\(pieces[14].rawValue)\n" + 
        "    |   |   |       |   |   |\n" +
        "5   |   |   \(pieces[15].rawValue)---\(pieces[16].rawValue)---\(pieces[17].rawValue)   |   |\n" + 
        "    |   |       |       |   |\n" +
        "6   |   \(pieces[18].rawValue)-------\(pieces[19].rawValue)-------\(pieces[20].rawValue)   |\n" +
        "    |           |           |\n" + 
        "7   \(pieces[21].rawValue)-----------\(pieces[22].rawValue)-----------\(pieces[23].rawValue)\n"

        outputHandler.display(output: boardTextVisualization)
    }
}

// private helper functions
extension Board {

    // removing the piece at index: index by assigning it to the empty type
    // and updating all the mills associated with this index
    private func doRemove(index: Int) {
        pieces[index] = PieceType.empty
        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndNotEmpty(index: index) }
        millsForIndex.forEach { (mill) in mill.remove(index: index)}
    }

    // checks whether two indices are adjacent
    private func isAdjacent(element index1: Int, adjacentTo index2: Int) -> Bool {
        return index1 < Constants.nodeNeighbours.count && 
               Constants.nodeNeighbours[index1].contains(index2)
    }
}
