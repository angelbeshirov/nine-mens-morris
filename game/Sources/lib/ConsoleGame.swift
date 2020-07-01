public class ConsoleGame {

    private var player1: Player
    private var player2: Player
    private var board: Board
    
    private var nextPlayer: PlayerType
    private var ioUtil: IOUtil

    // var ioUtil: IOUtil { // TODO add interface
    //     set {
    //         ioUtil = newValue
    //     }
    //     get {
    //         return ioUtil
    //     }
    // }

    public init(ioUtil: IOUtil) throws {
        self.ioUtil = ioUtil
        let colors: (PlayerColor, PlayerColor) = try ioUtil.getPlayerColors()

        board = Board(_size: 24)
        player1 = Player(color: colors.0, board: board)
        player2 = Player(color: colors.1, board: board)
        nextPlayer = PlayerType.player1
    }

    public func startPlacingPhase() throws {
        board.visualize()

        while player1.hasPieces() || player2.hasPieces() {
            print("\(nextPlayer.rawValue) please enter coordinates to place a piece:")
            let coordinates = try ioUtil.getSingleCoordinates()

            do {
                if nextPlayer == PlayerType.player1 { // TODO next player can be put in a property which to be calculated based on the previous next
                    try player1.assign(index: coordinates)
                    print("\(nextPlayer.rawValue), you have \(player1.getPieces()) left")
                    nextPlayer = PlayerType.player2
                } else {
                    try player2.assign(index: coordinates)
                    print("\(nextPlayer.rawValue), you have \(player2.getPieces()) left")
                    nextPlayer = PlayerType.player1
                }
            } catch {
                print("The coordinates you have entered are invalid: \(error)")
                print("Please try again")
                continue
            }
            
            board.visualize()
        }
    }

    // public func start() {
    //     // let ioUtil: IOUtil = IOUtil()
    //     let colors: (Color, Color) = ioUtil.getPlayerColors()

    //     var player1Turn = true

    //     board.visualize()

    //     // phase 2 (adjacent positions only)

    //     while player1.getPlacedPieces() > 2 && player2.getPlacedPieces() > 2 {
    //         if player1Turn {
    //             print("Player 1 please enter coordinates to move a piece")
    //             let coordinates: (Int, Int) = ioUtil.getDoubleCoordinates()
    //             player1.movePiece(index1: coordinates.0, index2: coordinates.1)
    //             player1Turn = false
    //         } else {
    //             print("Player 2 please enter coordinates to move a piece:")
    //             let coordinates: (Int, Int) = ioUtil.getDoubleCoordinates()
    //             player2.movePiece(index1: coordinates.0, index2: coordinates.1)
    //             player1Turn = true
    //         }

    //         board.visualize()
    //     }
    // }
}
