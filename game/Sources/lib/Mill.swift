class Mill {
    // pieceIndex (0-23) -> PieceType
    private var pieces: [Int: PieceType] 
    private var _isFormed: Bool

    public init(indices: [Int]) {
        self.pieces = [Int: PieceType]()
        self._isFormed = false
        for index in indices {
            pieces[index] = PieceType.empty
        }
    }
}

// logic to check whether the mill is completed or not
extension Mill {
    // computed property to check whether the mill is completed or not
    var isFormed: Bool {
        get {
            return _isFormed
        }
    }

    private func isMillFormed() -> Bool {
        guard let firstPieceType = pieces.first?.1 else {
            return false
        }

        return pieces.filter { (key, value) in value == firstPieceType }.count == pieces.count
    }
}

// predicate boolean functions for index validations before any operations are done
// the Board class is responsible to ensuring the correctness of the Mill class state
// as it contains all the pieces 
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
    func assign(index: Int, pieceType: PieceType) {
        pieces[index] = pieceType
        _isFormed = isMillFormed()
    }

    func remove(index: Int) {
        pieces[index] = PieceType.empty
        _isFormed = false
    }
}