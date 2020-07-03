class Mill {
    // pieceIndex (0-23) -> PieceType
    private var pieces: [Int: PieceType] 
    private var _isFormed: Bool

    // computed property to check whether the mill is completed or not
    var isFormed: Bool {
        get {
            return _isFormed
        }
    }

    public init(indices: [Int]) {
        self.pieces = [Int: PieceType]()
        self._isFormed = false
        for index in indices {
            pieces[index] = PieceType.empty
        }
    }

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

    func assign(index: Int, pieceType: PieceType) {
        pieces[index] = pieceType
        _isFormed = isMillFormed()
    }

    func remove(index: Int) {
        pieces[index] = PieceType.empty
        _isFormed = false
    }

    private func isMillFormed() -> Bool {
        guard let firstPieceType = pieces.first?.1 else {
            return false
        }

        return pieces.filter { (key, value) in value == firstPieceType }.count == pieces.count
    }
}