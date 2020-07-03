public class ConsoleIOHandler {

    public func getPlayerColors() throws -> (PlayerColor, PlayerColor) {
        var player1Color: PlayerColor? = nil
        var player2Color: PlayerColor? = nil

        print("Please enter the color of the pools for player 1 [black/white]:")
        while let input = readLine() {
            let choice = input.lowercased()
            
            if let color = PlayerColor(rawValue: choice) {
                player1Color = color
                switch color {
                case .black:
                    player2Color = PlayerColor.white
                case .white:
                    player2Color = PlayerColor.black
                }
                break
            } else {
                print("Invalid input, please enter either [black/white]")
            }
        }

        guard let player1FinalColor = player1Color, let player2FinalColor = player2Color else {
            throw IOError.failedToGetInitialColors
        }

        return (player1FinalColor, player2FinalColor)
    }

    public func getSingleCoordinates() throws -> (Int) {
        var coordinates1d: Int? = nil;
        
        while let input = readLine() {
            let coordinates2d = input.lowercased()

            if let transformedCoordinates = BoardConstants.coordinateMapping[coordinates2d] {
                coordinates1d = transformedCoordinates
                break
            } else {
                print("The coordinates you have entered does not exist on this board, please try again");
            }
        }

        guard let finalCoordinates = coordinates1d else {
            throw IOError.failedToGetCoordinates
        }

        return finalCoordinates
    }

    public func getDoubleCoordinates() throws -> (Int, Int) {
        var coordinates1dFirst: Int? = nil;
        var coordinates1dSecond: Int? = nil;

        while let input = readLine() {
            guard input.count == 4 else {
                print("The coordinates you have entered are invalid, please try again");
                continue
            }

            let move2dCoordinates = input.lowercased()

            if let transformedCoordinatesFirst = BoardConstants.coordinateMapping[String(move2dCoordinates.prefix(2))],
               let transformedCoordinatesSecond = BoardConstants.coordinateMapping[String(move2dCoordinates.suffix(2))] {
                coordinates1dFirst = transformedCoordinatesFirst
                coordinates1dSecond = transformedCoordinatesSecond
                break
            } else {
                print("The coordinates you have entered are invalid, please try again"); // change to some constant REPEATED??
            }
        }

        guard let finalCoordinates1dFirst = coordinates1dFirst, 
              let finalCoordinates1dSecond = coordinates1dSecond else {
            throw IOError.failedToGetCoordinates
        }

        return (finalCoordinates1dFirst, finalCoordinates1dSecond)
    }
}