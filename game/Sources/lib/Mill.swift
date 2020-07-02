class Mill {
    private var id: Int
    private var pieces: [Int: PieceType] // id -> PieceType
    private var ids: [Int]

    private var _isFormed: Bool

    // computed property to check whether the mill is complete or not
    var isFormed: Bool {
        get {
            return _isFormed
        }
    }

    public init(id: Int, ids: [Int]) {
        self.id = id
        self.ids = ids
        self._isFormed = false
        // mapping from id to piece type
        self.pieces = [Int: PieceType]()
        for element in ids {
            pieces[element] = PieceType.empty
        }
        // print(pieces)
    }

    func hasId(id: Int) -> Bool {
        return pieces[id] != nil
    }

    func hasIdAndEmpty(id: Int) -> Bool {
        return pieces[id] == PieceType.empty
    }

    func assign(index: Int, pieceType: PieceType) throws {
        guard hasIdAndEmpty(id: index) else {
            throw InputError.InvalidAssignPieceID
        }

        pieces[index] = pieceType

        _isFormed = isMillFormed()
    }

// CHANGE ID AND INDEX
    func remove(index: Int) throws {
        guard hasId(id: index) && !hasIdAndEmpty(id: index) else {
            throw InputError.InvalidRemovePieceID
        }

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