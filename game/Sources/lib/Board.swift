public class Board {

    private var range = (0...23);

    var size: Int
    var pieces: [PieceType]

    // var lostGame: Bool {
    //     get {
    //         return hasLost()
    //     }
    // }

    public init(_size: Int) {
        self.size = _size
        self.pieces = Array(repeating: PieceType.empty, count: _size)
    }

    public func assign(index: Int, color: PlayerColor) throws {
        // TODO check if there is any point in separating this into 2 exception
        if range.contains(index) && pieces[index] == PieceType.empty {
            pieces[index] = color.pieceType
        } else {
            throw InputError.InvalidPieceID
        }
    }

    public func remove(index: Int) throws {
        if range.contains(index) && pieces[index] == PieceType.empty {
            pieces[index] = PieceType.empty
        } else {
            throw InputError.InvalidPieceID
        }
    }

    public func move(from: Int, to: Int) throws {
        guard range.contains(from) && range.contains(to) else {
            throw InputError.InvalidPieceID
        }

        guard pieces[from] != PieceType.empty && pieces[to] == PieceType.empty else {
            throw InputError.InvalidMovePieceIDs
        }

        pieces[to] = pieces[from]
        pieces[from] = PieceType.empty
    }

    public func getPieceAt(at: Int) -> PieceType? {
        if !range.contains(at) {
            return nil
        }

        return pieces[at]
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
}
