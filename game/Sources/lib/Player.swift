public class Player {
    var color: Color;
    var board: Board;
    var initialMoves: Int;
    var placedPieces: Int;

    public init(Color color, Board board) {
        self.color = color;
        self.board = board;
        self.initialMoves = 9;
        self.placedPieces = 0;
    }

    public func assign(index: Int) {
        board.assign(index: index, color: self.color)
    }

    public func removePiece(index: Int) {
        // TODO
    }

    public func movePiece(index1: Int, index2: Int) {
        // TODO
    }
}
