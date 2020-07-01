public class IOUtil {

    public init() {
 
    }

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
                print("Invalid choice, please enter either [black/white]")
            }
        }

        guard let player1FinalColor = player1Color, let player2FinalColor = player2Color else {
            throw IOError.FailedToGetInitialColors
        }

        return (player1FinalColor, player2FinalColor)
    }

    public func getSingleCoordinates() throws -> (Int) {
        var coordinate1d: Int? = nil;
        
        //print("Please enter coordinate for piece placement [a-h][1-8]:")

        while let input = readLine() {
            let coord2d = input.lowercased()

            if let transformedCoordinate = BoardConstants.coordinateMapping[coord2d] {
                coordinate1d = transformedCoordinate
                break
            } else {
                print("The coordinate you have entered does not exist on this board, please try again");
            }
        }

        guard let finalCoordinate = coordinate1d else {
            throw IOError.FailedToGetCoordinates
        }

        return finalCoordinate
    }

    public func getDoubleCoordinates() throws -> (Int, Int) {
        var coordinate1dFirst: Int? = nil;
        var coordinate1dSecond: Int? = nil;

        while let input = readLine() {
            guard input.count == 4 else {
                print("The coordinate you have entered is invalid, please try again");
                continue
            }

            let move2dCoord = input.lowercased()

            if let transformedCoordinateFirst = BoardConstants.coordinateMapping[String(move2dCoord.prefix(2))],
               let transformedCoordinateSecond = BoardConstants.coordinateMapping[String(move2dCoord.suffix(2))] {
                coordinate1dFirst = transformedCoordinateFirst
                coordinate1dSecond = transformedCoordinateSecond
                break
            } else {
                print("The coordinate you have entered is invalid, please try again");
            }
        }

        guard let finalCoordinate1dFirst = coordinate1dFirst, 
              let finalCoordinate1dSecond = coordinate1dSecond else {
            throw IOError.FailedToGetCoordinates
        }

        return (finalCoordinate1dFirst, finalCoordinate1dSecond)
    }
}