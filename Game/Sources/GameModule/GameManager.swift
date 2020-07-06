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
        self.outputHandler = ConsoleOutputHandler()

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
            try game = ConsoleGame(inputHandler: consoleInputHandler, outputHandler: consoleOutputHandler)
            try game!.startPlacingPhase()
            try game!.startMovingPhase()
            try game!.startFlyingPhase()
            try game!.handleGameOverPhase()
        } catch let inputError as InputError {
            consoleOutputHandler.display(output: "Input error: \(inputError)")
        } catch GameError.gameIsNotOver {
            consoleOutputHandler.display(output: "Internal error: Game is not in game over state!")
        } catch {
            // handle all unknown errors
            consoleOutputHandler.display(output: "Unknown fatal error: \(error)")
        }
    }
}