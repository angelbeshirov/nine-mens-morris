public class GameManager {

    private var game: ConsoleGame?;
    private var ioHandler: ConsoleIOHandler?; // change to interface later

    public init() {
        self.game = nil
        self.ioHandler = nil
    }

    public func startConsoleGame() {
        self.ioHandler = ConsoleIOHandler()
        guard let ioHandlerInitialized = self.ioHandler else {
            print("Error while initializing input/output service")
            return
        }

        do {
            try game = ConsoleGame(ioHandler: ioHandlerInitialized) // TODO change to interface
            try game!.startPlacingPhase()
            try game!.startMovingPhase()
            try game!.startFlyingPhase()
        } catch {
            // change this to be handled by ErrorHandler
            // add better error handling
            print("Critical error encountered: \(error)")
        }
    }
}