public protocol InputHandler {
    func getPlayerColors() throws -> (PlayerColor, PlayerColor)
    func getSingleCoordinates() throws -> (Int)
    func getDoubleCoordinates() throws -> (Int, Int)
}

// This is a concrete implementation of the InputHandler i.e. ConsoleInputHandler, print is okay
public class ConsoleInputHandler: InputHandler {

    public func getPlayerColors() throws -> (PlayerColor, PlayerColor) {
        var player1Color: PlayerColor? = nil
        var player2Color: PlayerColor? = nil

        print(ConsoleMessages.enterColorsPrompt)
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
                print(ConsoleMessages.invalidColors)
            }
        }

        guard let player1FinalColor = player1Color, let player2FinalColor = player2Color else {
            throw InputError.failedToGetInitialColors
        }

        return (player1FinalColor, player2FinalColor)
    }

    public func getSingleCoordinates() throws -> (Int) {
        var coordinates1d: Int? = nil;
        
        while let input = readLine() {
            let coordinates2d = input.lowercased()

            if let transformedCoordinates = Board.Constants.coordinateMapping[coordinates2d] {
                coordinates1d = transformedCoordinates
                break
            } else {
                print(ConsoleMessages.invalidCoordinates);
            }
        }

        guard let finalCoordinates = coordinates1d else {
            throw InputError.failedToGetCoordinates
        }

        return finalCoordinates
    }

    public func getDoubleCoordinates() throws -> (Int, Int) {
        var coordinates1dFirst: Int? = nil;
        var coordinates1dSecond: Int? = nil;

        while let input = readLine() {
            guard input.count == 4 else {
                print(ConsoleMessages.invalidCoordinates);
                continue
            }

            let move2dCoordinates = input.lowercased()

            if let transformedCoordinatesFirst = Board.Constants.coordinateMapping[String(move2dCoordinates.prefix(2))],
               let transformedCoordinatesSecond = Board.Constants.coordinateMapping[String(move2dCoordinates.suffix(2))] {
                coordinates1dFirst = transformedCoordinatesFirst
                coordinates1dSecond = transformedCoordinatesSecond
                break
            } else {
                print(ConsoleMessages.invalidCoordinates);
            }
        }

        guard let finalCoordinates1dFirst = coordinates1dFirst, 
              let finalCoordinates1dSecond = coordinates1dSecond else {
            throw InputError.failedToGetCoordinates
        }

        return (finalCoordinates1dFirst, finalCoordinates1dSecond)
    }
}