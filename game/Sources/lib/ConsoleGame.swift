public class ConsoleGame {
    private var player1: Player
    private var player2: Player
    private var board: Board
    
    private var playerToMove: PlayerType
    private var ioHandler: ConsoleIOHandler

    var nextPlayer: PlayerType {
        get {
            if playerToMove == PlayerType.player1 {
                return PlayerType.player2
            }

            return PlayerType.player1
        }
    }

    var gameState: GameState {
        get {
            // all pieces have been place when this is false
            if player1.hasPiecesToPlace || player2.hasPiecesToPlace { 
                return GameState.placingPieces
            } else if player1.placedPieces > 3 && player2.placedPieces > 3 {
                return GameState.movingPieces
            } else if player1.placedPieces == 3 || player2.placedPieces == 3 {
                return GameState.flyingPieces
            } else {
                return GameState.gameOver
            }
        }
    }

    private var currentPlayerObject: Player {
        return getPlayerObject(playerType: playerToMove)
    }

    private var nextPlayerObject: Player {
        return getPlayerObject(playerType: nextPlayer)
    }

    // var ioUtil: IOUtil { // TODO add interface
    //     set {
    //         ioUtil = newValue
    //     }
    //     get {
    //         return ioUtil
    //     }
    // }

    public init(ioHandler: ConsoleIOHandler) throws {
        self.ioHandler = ioHandler
        let colors: (PlayerColor, PlayerColor) = try ioHandler.getPlayerColors()

        board = Board(_size: 24)
        player1 = Player(color: colors.0, board: board)
        player2 = Player(color: colors.1, board: board)
        playerToMove = PlayerType.player1
        print("The game has started!")
        print("Player 1 has \(colors.0.rawValue) pieces, Player 2 has \(colors.1.rawValue) pieces")
    }

    public func startPlacingPhase() throws {
        var hasToRemove: Bool = false
        board.visualize()

        while gameState == GameState.placingPieces || hasToRemove {
            if !hasToRemove {
                print("\(playerToMove.rawValue) please enter coordinates to place a piece:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    hasToRemove = try currentPlayerObject.assign(index: coordinates)
                    print("\(playerToMove.rawValue), you have \(currentPlayerObject.piecesToPlace) pieces left to place")
                    board.visualize()
                } catch {
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }
            }

            if hasToRemove {
                print("\(playerToMove.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    print("\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                } catch {
                    // Change to more specific error handling
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }

                hasToRemove = false
            }

            playerToMove = nextPlayer
        }
    }

    public func startMovingPhase() throws {
        var hasToRemove: Bool = false
        print("All pieces have been placed, starting phase 2 - moving pieces")

        while gameState == GameState.movingPieces || hasToRemove {
            if !hasToRemove {
                print("\(playerToMove.rawValue) please enter coordinates to move a piece:")
                let coordinates: (Int, Int) = try ioHandler.getDoubleCoordinates()

                do {
                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, index2: coordinates.1)
                    board.visualize()
                } catch {
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }
            }

            if hasToRemove {
                print("\(playerToMove.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    print("\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                } catch {
                    // Change to more specific error handling
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }

                hasToRemove = false
            }

            playerToMove = nextPlayer
        }
    }

    public func startFlyingPhase() throws {
        let playerLeftWith3Pieces = currentPlayerObject.placedPieces == 3 ? playerToMove : nextPlayer
        print("\(playerLeftWith3Pieces.rawValue) you have 3 pieces left, starting phase 3 - flying")
        var hasToRemove: Bool = false;

        while gameState == GameState.flyingPieces || hasToRemove {
            if !hasToRemove {
                print("\(playerToMove.rawValue) please enter coordinates to move a piece:")
                let coordinates: (Int, Int) = try ioHandler.getDoubleCoordinates()
                let adjacent: Bool = playerLeftWith3Pieces != playerToMove // is this okay to compare enums?

                do {
                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, 
                                                                    index2: coordinates.1, 
                                                                    adjacentOnly: adjacent)
                    board.visualize()
                } catch {
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }
            }

            if hasToRemove {
                print("\(playerToMove.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    print("\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                } catch {
                    // Change to more specific error handling
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }

                hasToRemove = false
            }

            playerToMove = nextPlayer
        }
    }

    private func getPlayerObject(playerType: PlayerType) -> Player {
        return playerType == PlayerType.player1 ? player1 : player2
    }
}
