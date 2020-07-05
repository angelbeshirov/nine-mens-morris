import IOModule

// Object representation of the mill on the board for the nine-mens-morris game.
class Mill {

    // pieceIndex (0-23) -> PieceType
    private var pieces: [Int: PieceType]

    // checks whether the mill is completed or not
    private var _isCompleted: Bool

    // initializes the mill with the indices it contains
    public init(indices: [Int]) {
        self.pieces = [Int: PieceType]()
        self._isCompleted = false
        for index in indices {
            pieces[index] = PieceType.empty
        }
    }
}

// logic to check whether the mill is completed or not
extension Mill {

    // computed property to check whether the mill is completed or not
    var isCompleted: Bool {
        get {
            return _isCompleted
        }
    }

    // private helper
    private func isMillCompleted() -> Bool {
        guard let firstPieceType = pieces.first?.1 else {
            return false
        }

        // if all pieces in this mill are of the same type then the mill is completed
        return pieces.filter { (key, value) in value == firstPieceType }.count == pieces.count
    }
}

// Predicate boolean functions for index validations before any operations are done.
// The board class is responsible to ensuring the correctness of the Mill class state
// as it contains all the pieces.
extension Mill {
    func hasIndex(index: Int) -> Bool {
        return pieces[index] != nil
    }

    func hasIndexAndEmpty(index: Int) -> Bool {
        return pieces[index] == PieceType.empty
    }

    // composition (handles also the nil case)
    func hasIndexAndNotEmpty(index: Int) -> Bool {
        return hasIndex(index: index) && !hasIndexAndEmpty(index: index)
    }
}

extension Mill {

    // assigs a piece type to a piece from this mill and checks whether the mill
    // has been completed or not
    func assign(index: Int, pieceType: PieceType) {
        pieces[index] = pieceType
        _isCompleted = isMillCompleted()
    }

    // removes a piece from this mill by assigning it to the empty initial type
    func remove(index: Int) {
        pieces[index] = PieceType.empty
        _isCompleted = false
    }
}