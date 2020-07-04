public class Board {

    private var size: Int
    private var outputHandler: OutputHandler
    private var pieces: [PieceType]
    private var mills: [Mill]

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
    public func assign(index: Int, color: PlayerColor) throws -> Bool {
        guard Constants.range.contains(index) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[index] == PieceType.empty else {
            throw BoardError.failedToAssignPiece(description: Constants.alreadyAssigned)
        }

        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndEmpty(index: index) }
        let millsFormed = millsForIndex.map{ $0.isFormed }

        pieces[index] = color.pieceType

        millsForIndex.forEach { (mill) in mill.assign(index: index, pieceType: color.pieceType)}
        let millsFormedAfterAssignment = millsForIndex.map{ $0.isFormed }

        return millsFormed != millsFormedAfterAssignment
    }
}

extension Board {
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

        let partOfCompetedMill = mills.filter { (mill) in mill.hasIndex(index: index) && mill.isFormed }.count > 0

        if partOfCompetedMill {
            let opponenetIndices: [Int] = pieces.enumerated()
                .filter { (idx, type) in type == pieceType }
                .map { (idx, type) in return idx }

            var allAreMills: Bool = true

            for idx in opponenetIndices {
                // if there are 0 formed mills for particular index then this index is not part of a mill otherwise it is
                if (mills.filter { (mill) in mill.hasIndex(index: idx) && mill.isFormed }.count == 0) {
                    allAreMills = false
                    break
                }
            }

            if !allAreMills {
                throw BoardError.failedToRemovePiece(description: Constants.tryingToRemoveFromMillWhenAvailable)
            }
        }

        doRemove(index: index)
    }
}

extension Board {
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
        // meaning if adjOnly is true then isAdjacent must also be true. Table is below
        // adjOnly isAdjecent
        // true true -> true
        // true false -> false
        // false true -> true
        // false false -> true
        guard !adjacentOnly || isAdjacent(element: from, adjacentTo: to) else {
            // the index is not adjacent to the initial index (for phase 2 and phase 3 for the player with more than 3 pieces)
            throw BoardError.failedToMovePiece(description: Constants.tryingToMoveToNonAdjacent)
        }

        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndEmpty(index: to) } // repeated
        let millsFormed = millsForIndex.map{ $0.isFormed }

        pieces[to] = pieces[from]
        doRemove(index: from)

        millsForIndex.forEach { (mill) in mill.assign(index: to, pieceType: pieces[to])}
        let millsFormedAfterAssignment = millsForIndex.map{ $0.isFormed }

        return millsFormed != millsFormedAfterAssignment
    }
}

extension Board {
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

extension Board {
    private func doRemove(index: Int) {
        pieces[index] = PieceType.empty
        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndNotEmpty(index: index) }
        millsForIndex.forEach { (mill) in mill.remove(index: index)}
    }

    private func isAdjacent(element index1: Int, adjacentTo index2: Int) -> Bool {
        return index1 < Constants.nodeNeighbours.count && 
               Constants.nodeNeighbours[index1].contains(index2)
    }
}
