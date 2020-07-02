public class ConsoleGame {

    private var player1: Player
    private var player2: Player
    private var board: Board
    
    private var playerToMove: PlayerType
    private var ioUtil: IOUtil

    var nextPlayer: PlayerType {
        get {
            if playerToMove == PlayerType.player1 {
                return PlayerType.player2
            }

            return PlayerType.player1
        }
    }

    var gameState: GameState {

        if player1.hasPieces || player2.hasPieces {
            return GameState.placingPieces
        } else if player1.placedPieces > 3 && player2.placedPieces > 3 {
            return GameState.movingPieces
        } else if player1.placedPieces == 3 || player2.placedPieces == 3 {
            return GameState.flyingPieces
        } else if player1.placedPieces < 3 || player2.placedPieces < 3 {
            return GameState.gameOver
        }

        return GameState.undefined
    }

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
                let coordinates = try ioUtil.getSingleCoordinates()

                do {
                    if playerToMove == PlayerType.player1 {
                        hasToRemove = try player1.assign(index: coordinates)
                        print("\(playerToMove.rawValue), you have \(player1.piecesToPlace) pieces left")
                    } else {
                        hasToRemove = try player2.assign(index: coordinates)
                        print("\(playerToMove.rawValue), you have \(player2.piecesToPlace) pieces left")
                    }

                    board.visualize()
                } catch {
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }
            }

            if hasToRemove {
                print("\(playerToMove.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioUtil.getSingleCoordinates()

                do {
                    if playerToMove == PlayerType.player1 {
                        try player1.removePiece(index: coordinates) 
                        // if you try to remove a piece from a mill and there are other pieces available throw exception
                    } else {
                        try player2.removePiece(index: coordinates)
                    }

                    // visualization as this is an extra move
                    board.visualize()
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

        // try player1.assign(index: 0)
        // try player1.assign(index: 2)
        // try player1.assign(index: 4)
        // try player1.assign(index: 6)
        // try player1.assign(index: 8)
        // try player1.assign(index: 11)
        // try player1.assign(index: 13)
        // try player1.assign(index: 14)
        // try player1.assign(index: 15)

        // try player2.assign(index: 1)
        // try player2.assign(index: 3)
        // try player2.assign(index: 5)
        // try player2.assign(index: 7)
        // try player2.assign(index: 9)
        // try player2.assign(index: 10)
        // try player2.assign(index: 12)
        // try player2.assign(index: 17)
        // try player2.assign(index: 22)
        // board.visualize()
    }

    public func startMovingPhase() throws {
        var hasToRemove: Bool = false
        print("All pieces have been placed, starting phase 2 - moving pieces")
        while gameState == GameState.movingPieces || hasToRemove {
            if !hasToRemove {
                print("\(playerToMove.rawValue) please enter coordinates to move a piece:")
                let coordinates: (Int, Int) = try ioUtil.getDoubleCoordinates()

                do {
                    if playerToMove == PlayerType.player1 {
                        hasToRemove = try player1.movePiece(index1: coordinates.0, index2: coordinates.1)
                    } else {
                        hasToRemove = try player2.movePiece(index1: coordinates.0, index2: coordinates.1)
                    }

                    board.visualize()
                } catch {
                    print("The coordinates you have entered are invalid: \(error)")
                    print("Please try again")
                    continue
                }
            }

            if hasToRemove {
                print("\(playerToMove.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioUtil.getSingleCoordinates()

                do {
                    if playerToMove == PlayerType.player1 {
                        try player1.removePiece(index: coordinates) 
                    } else {
                        try player2.removePiece(index: coordinates)
                    }

                    // visualization as this is an extra move
                    board.visualize()
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
        print("One of the players is left with 3 pieces, starting phase 3 - flying")
        var hasToRemove: Bool = false;
        while gameState == GameState.flyingPieces {
            print("\(playerToMove.rawValue) please enter coordinates to move a piece:")
            let coordinates: (Int, Int) = try ioUtil.getDoubleCoordinates()

            do {
                if playerToMove == PlayerType.player1 {
                    hasToRemove = try player1.movePiece(index1: coordinates.0, index2: coordinates.1)
                } else {
                    hasToRemove = try player2.movePiece(index1: coordinates.0, index2: coordinates.1)
                }
            } catch {
                print("The coordinates you have entered are invalid: \(error)")
                print("Please try again")
                continue
            }

            playerToMove = nextPlayer
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
