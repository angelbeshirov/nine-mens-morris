import IOModule

// The class is used for starting different game versions and
// using different i/o handlers if neccessary. This can be done
// by implementing the specific protocols (Game, InputHandler or OutputHandler).
public class GameManager {

    private var game: Game?
    private var inputHandler: InputHandler?
    private var outputHandler: OutputHandler?

    public init() {
        self.game = nil
        self.inputHandler = nil
        self.outputHandler = nil
    }
}

extension GameManager {

    // Starts the console version of the game by initializing the i/o handlers
    // and starting the game phases.
    public func startConsoleGame() {
        self.outputHandler = ConsoleOutputAndErrorHandler()

        // The i/o handlers here are not yet initialized so we use the primitive 
        // print which in this case is the same as the one in the implementation 
        // of the console version, but in general it can be different and this 
        // will make it easier to generalize.
        guard let consoleOutputHandler = self.outputHandler else {
            print("Failed to initialize output handler.")
            return
        }

        self.inputHandler = ConsoleInputHandler(outputHandler: consoleOutputHandler)

        guard let consoleInputHandler = self.inputHandler else {
            print("Failed to initialize input handler.")
            return
        }

        do {
            // if the game is not initialized correctly error will be thrown
            try game = ConsoleGame(inputHandler: consoleInputHandler, outputHandler: consoleOutputHandler)

            // main game loop
            while game?.gameState != GameState.gameOver {
                switch game?.gameState {
                case .placingPieces: try game!.startPlacingPhase()
                case .movingPieces: try game!.startMovingPhase()
                case .flyingPieces: try game!.startFlyingPhase()
                default: throw GameError.wrongGameState
                }
            }

            try game!.handleGameOverPhase()

        } catch let inputError as InputError {
            consoleOutputHandler.displayError(error: "Input error: \(inputError)")
        } catch GameError.wrongGameState {
            consoleOutputHandler.displayError(error: "Internal error: Game is in the wrong state!")
        } catch {
            // handle all unknown errors
            consoleOutputHandler.displayError(error: "Unknown fatal error: \(error)")
        }
    }
}