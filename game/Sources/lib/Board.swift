public enum Piece: String {
    case empty = "·"
    case white = "○"
    case black = "●"
}

public class Board {

    var size: Int;
    var pieces: [Piece];

    public init(size: Int) {
        self.size = size;
        self.pieces = Array(repeating: Piece.empty, count: 24)
    }

    public func assign(index: Int, color: Color) {
        if index >= 24 {
            // throw exception
            return;
        }

        if pieces[index] != Piece.empty {
            // throw exception
            // square is already filled
            return;
        }

        // might be possible to unify this enum?
        switch color {
        case .black:
            pieces[index] = Piece.black;
        case .white:
            pieces[index] = Piece.white
        }
    }

    public func remove(index: Int) {
        if index >= 24 {
            // throw exception
            return;
        }

        if pieces[index] == Piece.empty {
            return;
            // can not remove empty piece
        }
        // the logic whether a player is removing his own piece should be done in the player class

        pieces[index] = Piece.empty;
    }

    public func move(from: Int, to: Int) {
        if from >= 24 || to >= 24 {
            // throw exception
            return;
        }


        // maybe change to guards
        if pieces[from] == Piece.empty || pieces[to] != Piece.empty {
            return;
            // can not remove empty piece
        }

        pieces[to] = pieces[from];
        pieces[from] = Piece.empty;
    }

    public func getPieceAt(at: Int) -> Piece? {
        if at >= 24 {
            return nil;
        }

        return pieces[at];
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
