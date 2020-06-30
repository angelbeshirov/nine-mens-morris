public class Runner {
    public init() {

    }

    public func start() {
        print("The game has started!");
        print("Player 1, please enter the color of your pools [black/white]:")
        let colorPlayer1 = readLine()
        var colorPlayer2 = "sth"
        if colorPlayer1! == "black" {
            colorPlayer2 = "white"
        } else {
            colorPlayer2 = "black"
        }
        print("Player 1 has the \(colorPlayer1!) color")
        print("Player 2 has the \(colorPlayer2) color")

        let board = Board();
        board.print_board()
    }
}
