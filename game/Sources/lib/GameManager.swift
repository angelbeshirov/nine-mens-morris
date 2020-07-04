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
    public func startConsoleGame() {
        self.inputHandler = ConsoleInputHandler()
        self.outputHandler = ConsoleOutputHandler()

        // The IO handlers here are not yet initialized so we use the primitive print
        // which in this case is the same as the one in the implementation for the console 
        // version, but in general it can be different and this will make it easier to generalize.
        guard let consoleInputHandler = self.inputHandler else {
            print("Failed to initialize input handler.")
            return
        }

        guard let consoleOutputHandler = self.outputHandler else {
            print("Failed to initialize output handler.")
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
            // change this to be handled by ErrorHandler
            consoleOutputHandler.display(output: "Internal error: Game is not in game over state!")
        } catch {
            consoleOutputHandler.display(output: "Unknown fatal error: \(error)")
        }
    }
}