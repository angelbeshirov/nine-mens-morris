// The input handler protocol which every class handling input from the user
// should implement if it uses the current game package.
public protocol InputHandler {

    // gets the colors for the two players
    func getPlayerColors() throws -> (PlayerColor, PlayerColor)

    // gets coordinates for a single piece on the board
    func getSingleCoordinates() throws -> (Int)

    // gets coordinates for two pieces on the board
    func getDoubleCoordinates() throws -> (Int, Int)
}

// Console implementation of the input handler protocol. Gets the input from the user 
// from the standard input. Uses an output handler to display any information or 
// errors to the user.
public class ConsoleInputHandler: InputHandler {

    // the output handler
    private var outputHandler: OutputHandler

    // public initializer which sets the output handler
    public init(outputHandler: OutputHandler) {
        self.outputHandler = outputHandler
    }
}

extension ConsoleInputHandler {

    // Gets the initial colors of the two players. Currently there are only
    // two colors so one input is enough to determine both colors. 
    // If EOF has been reached when readLine() is called the first time in 
    // the beginning of the while loop InputError.failedToGetInitialColors 
    // will be thrown as the colors can't be initialized.
    public func getPlayerColors() throws -> (PlayerColor, PlayerColor) {
        var player1Color: PlayerColor? = nil
        var player2Color: PlayerColor? = nil

        outputHandler.display(output: Constants.enterColorsPrompt)
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
                // invalid input by unknown rawValue (invalid color)
                outputHandler.display(output: Constants.invalidColors)
            }
        }

        // this guard is if the initial check in the while fails when readLine returns nil
        guard let player1FinalColor = player1Color, let player2FinalColor = player2Color else {
            throw InputError.failedToGetInitialColors
        }

        return (player1FinalColor, player2FinalColor)
    }
}

extension ConsoleInputHandler {
    
    // Gets coordinates for a single piece on the board. This method can be 
    // used for getting coordinate of pieces for assignment and removal where only
    // the coordinates of a single piece are needed. If EOF has been reached when 
    // readLine() is called the first time in the beginning of the while loop 
    // InputError.failedToGetInitialColors will be thrown as the colors can't be initialized.
    public func getSingleCoordinates() throws -> (Int) {
        var coordinates1d: Int? = nil;
        
        while let input = readLine() {
            let coordinates2d = input.lowercased()

            if let transformedCoordinates = Constants.coordinateMapping[coordinates2d] {
                coordinates1d = transformedCoordinates
                break
            } else {
                // the input doesn't have a mapping in the coordinateMapping dict
                outputHandler.display(output: Constants.invalidCoordinates)
            }
        }

        // if readLine returns nil
        guard let finalCoordinates = coordinates1d else {
            throw InputError.failedToGetCoordinates
        }

        return finalCoordinates
    }
}

extension ConsoleInputHandler {
    
    // Gets coordinates for double pieces on the board. This method can be used for getting
    // coordinates of piece which has to be moved from 1 tile to another. If EOF has been 
    // reached when  readLine() is called the first time in the beginning of the while loop 
    // InputError.failedToGetInitialColors will be thrown as the colors can't be initialized.
    public func getDoubleCoordinates() throws -> (Int, Int) {
        var coordinates1dFirst: Int? = nil;
        var coordinates1dSecond: Int? = nil;

        while let input = readLine() {
            guard input.count == 4 else {
                outputHandler.display(output: Constants.invalidDoubleCoordinates);
                continue
            }

            let move2dCoordinates = input.lowercased()

            if let transformedCoordinatesFirst = Constants.coordinateMapping[String(move2dCoordinates.prefix(2))],
               let transformedCoordinatesSecond = Constants.coordinateMapping[String(move2dCoordinates.suffix(2))] {
                coordinates1dFirst = transformedCoordinatesFirst
                coordinates1dSecond = transformedCoordinatesSecond
                break
            } else {
                // one of the two coordinates from the input doesn't have 
                // a mapping in the coordinateMapping dict
                outputHandler.display(output: Constants.invalidCoordinates);
            }
        }

        // if readLine returns nil
        guard let finalCoordinates1dFirst = coordinates1dFirst, 
              let finalCoordinates1dSecond = coordinates1dSecond else {
            throw InputError.failedToGetCoordinates
        }

        return (finalCoordinates1dFirst, finalCoordinates1dSecond)
    }
}