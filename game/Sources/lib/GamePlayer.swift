public class GamePlayer {

    private var game: ConsoleGame?;
    private var ioUtil: IOUtil?;

    public init() {
        // self.game = ConsoleGame() // TODO change to interface
        self.game = nil
        self.ioUtil = nil
    }

    public func startConsoleGame() {
        self.ioUtil = IOUtil()
        guard let ioService = self.ioUtil else {
            print("Error while initializing input/output service")
            return
        }

        do {
            try game = ConsoleGame(ioUtil: ioService)
            try game!.startPlacingPhase()
            try game!.startMovingPhase()
            // game!.startFlyingPhase()
        } catch {
            //change this to be handled by ErrorHandler
            print("Critical error encountered: \(error)")
        }
    }
}