public class Board {

    var size: Int
    var pieces: [PieceType]
    var mills: [Mill]

    public init(_size: Int) {
        self.size = _size
        self.pieces = Array(repeating: PieceType.empty, count: _size)
        self.mills = [Mill]()

        for element in BoardConstants.millIndices {
            mills.append(Mill(indices: element))
        }
    }

    public func assign(index: Int, color: PlayerColor) throws -> Bool {
        guard BoardConstants.range.contains(index) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[index] == PieceType.empty else {
            throw BoardError.failedToAssignPiece(description: "The piece you are trying to assign is already assigned.")
        }

        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndEmpty(index: index) }
        let millsFormed = millsForIndex.map{ $0.isFormed }

        pieces[index] = color.pieceType

        millsForIndex.forEach { (mill) in mill.assign(index: index, pieceType: color.pieceType)}
        let millsFormedAfterAssignment = millsForIndex.map{ $0.isFormed }

        return millsFormed != millsFormedAfterAssignment
    }

    public func remove(index: Int, pieceType: PieceType) throws {
        guard BoardConstants.range.contains(index) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[index] != PieceType.empty else {
            throw BoardError.failedToRemovePiece(description: "The piece you are trying to remove is empty.")
        }

        guard pieces[index] == pieceType else {
            throw BoardError.failedToRemovePiece(description: "The piece you are trying to remove is not assigned by you.")
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
                throw BoardError.failedToRemovePiece(description: 
                "The piece you are trying to remove is part of a mill, while there are free pieces which are not part of any mills.")
            }
        }

        doRemove(index: index)
    }

    public func move(from: Int, to: Int, fromPieceType: PieceType, adjacentOnly: Bool) throws -> Bool {
        guard BoardConstants.range.contains(from) && BoardConstants.range.contains(to) else {
            throw BoardError.indexOutOfRange
        }

        guard pieces[from] != PieceType.empty else {
            throw BoardError.failedToMovePiece(description: "The piece you are trying to move is empty.")
        }

        guard pieces[from] == fromPieceType else {
            throw BoardError.failedToMovePiece(description: "The piece you are trying to move is not assigned by you.")
        }

        guard pieces[to] == PieceType.empty else {
            throw BoardError.failedToMovePiece(description: "You are trying to move a piece to an already assigned index.")
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
            throw BoardError.failedToMovePiece(
                description: "You are trying to move a piece to a non-adjacent index while you have more than 3 pieces left.")
        }

        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndEmpty(index: to) } // repeated
        let millsFormed = millsForIndex.map{ $0.isFormed }

        pieces[to] = pieces[from]
        doRemove(index: from)

        millsForIndex.forEach { (mill) in mill.assign(index: to, pieceType: pieces[to])}
        let millsFormedAfterAssignment = millsForIndex.map{ $0.isFormed }

        return millsFormed != millsFormedAfterAssignment
    }

    public func visualize() {
        print("    A   B   C   D   E   F   G")
        print("1   \(pieces[0].rawValue)-----------\(pieces[1].rawValue)-----------\(pieces[2].rawValue)")
        print("    |           |           |")
        print("2   |   \(pieces[3].rawValue)-------\(pieces[4].rawValue)-------\(pieces[5].rawValue)   |")
        print("    |   |       |       |   |")
        print("3   |   |   \(pieces[6].rawValue)---\(pieces[7].rawValue)---\(pieces[8].rawValue)   |   |")
        print("    |   |   |       |   |   |")
        print("4   \(pieces[9].rawValue)---\(pieces[10].rawValue)---\(pieces[11].rawValue)    ", terminator: "")
        print("   \(pieces[12].rawValue)---\(pieces[13].rawValue)---\(pieces[14].rawValue)")
        print("    |   |   |       |   |   |")
        print("5   |   |   \(pieces[15].rawValue)---\(pieces[16].rawValue)---\(pieces[17].rawValue)   |   |")
        print("    |   |       |       |   |")
        print("6   |   \(pieces[18].rawValue)-------\(pieces[19].rawValue)-------\(pieces[20].rawValue)   |")
        print("    |           |           |")
        print("7   \(pieces[21].rawValue)-----------\(pieces[22].rawValue)-----------\(pieces[23].rawValue)")
    }

    private func doRemove(index: Int) {
        pieces[index] = PieceType.empty
        let millsForIndex = mills.filter { (mill) in mill.hasIndexAndNotEmpty(index: index) }
        millsForIndex.forEach { (mill) in mill.remove(index: index)}
    }

    private func isAdjacent(element index1: Int, adjacentTo index2: Int) -> Bool {
        return index1 < BoardConstants.nodeNeighbours.count && 
               BoardConstants.nodeNeighbours[index1].contains(index2)
    }
}
