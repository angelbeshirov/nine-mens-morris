public class GameManager {

    private var game: ConsoleGame?;
    private var ioHandler: ConsoleIOHandler?; // change to interface later

    public init() {
        self.game = nil
        self.ioHandler = nil
    }

    public func startConsoleGame() {
        self.ioHandler = ConsoleIOHandler()
        guard let initializedIOHandler = self.ioHandler else {
            print("Error while initializing input/output service")
            return
        }

        do {
            try game = ConsoleGame(ioHandler: initializedIOHandler) // TODO change to interface
            try game!.startPlacingPhase()
            try game!.startMovingPhase()
            try game!.startFlyingPhase()
            try game!.handleGameOver()
        } catch let error as IOError {
            print("IO error: \(error)")
        } catch GameError.gameIsNotOver {
            // change this to be handled by ErrorHandler
            print("Internal error: Game is not in game over state!")
        } catch {
            print("Unknown fatal error. \(error)")
        }
    }
}