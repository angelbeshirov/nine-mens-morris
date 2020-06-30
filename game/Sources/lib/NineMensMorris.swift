public enum Color: String {
    case black
    case white
}

public class Runner {
    public init() {

    }

    public func start() {
        let colors: (Color, Color) = chooseColors();

        let board = Board(size: 7);
        board.assign(index: 5, color: Color.white)
        board.visualize();
    }

    public func chooseColors() -> (Color, Color) {
        var colorPlayer1: Color = Color.black; // TODO this should be initialized directly without this initial black value
        var colorPlayer2: Color = Color.black;

        print("Player 1, please enter the color of your pools [black/white]:")
        while let choice = readLine() {
            let lowerCased = choice.lowercased()
            
            if let color = Color(rawValue: lowerCased) {
                colorPlayer1 = color;
                switch color {
                case .black:
                    colorPlayer2 = Color.white
                case .white:
                    colorPlayer2 = Color.black
                }
                break;
            } else {
                print("Invalid choice, please enter either [black/white]")
            }
        }

        print("");
        print("The game has started!");
        print("Player 1 has the \(colorPlayer1) color")
        print("Player 2 has the \(colorPlayer2) color")

        return (colorPlayer1, colorPlayer2)
    }
}
