public class ConsoleGame {
    private var player1: Player
    private var player2: Player
    private var board: Board
    
    private var currentPlayer: PlayerType
    private var ioHandler: ConsoleIOHandler
    
    private var currentPlayerObject: Player {
        return getPlayerObject(playerType: currentPlayer)
    }

    private var nextPlayerObject: Player {
        return getPlayerObject(playerType: nextPlayer)
    }

    var nextPlayer: PlayerType {
        get {
            if currentPlayer == PlayerType.player1 {
                return PlayerType.player2
            }

            return PlayerType.player1
        }
    }

    var gameState: GameState {
        get {
            // all pieces have been placed when this is false
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

    public init(ioHandler: ConsoleIOHandler) throws {
        self.ioHandler = ioHandler
        let colors: (PlayerColor, PlayerColor) = try ioHandler.getPlayerColors()

        board = Board(_size: GameConstants.boardSize)
        player1 = Player(color: colors.0, board: board)
        player2 = Player(color: colors.1, board: board)
        currentPlayer = PlayerType.player1
        print("The game has started!")
        print("\(currentPlayer.rawValue) has \(colors.0.rawValue) pieces, \(nextPlayer.rawValue) has \(colors.1.rawValue) pieces")
        print(GameConstants.screenSeparator)
    }

    public func startPlacingPhase() throws {
        var hasToRemove: Bool = false
        board.visualize()

        while gameState == GameState.placingPieces || hasToRemove {
            if !hasToRemove {
                print("\(currentPlayer.rawValue) please enter coordinates to place a piece:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    hasToRemove = try currentPlayerObject.assign(index: coordinates)
                    print("\(currentPlayer.rawValue), you have \(currentPlayerObject.piecesToPlace) pieces left to place")
                    board.visualize()
                } catch BoardError.indexOutOfRange {
                    print("The coordinates for piece assignment are outside the board!")
                    print("Please try again.")
                    continue
                } catch BoardError.failedToAssignPiece(let description) {
                    print(description)
                    print("Please try again.")
                    continue
                }
            }

            if hasToRemove {
                print("\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    print("\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                } catch BoardError.indexOutOfRange {
                    print("The coordinates for piece removal are outside the board!")
                    print("Please try again.")
                    continue
                } catch BoardError.failedToRemovePiece(let description) {
                    print(description)
                    print("Please try again.")
                    continue
                }

                hasToRemove = false
            }

            currentPlayer = nextPlayer
        }

        print(GameConstants.screenSeparator)
    }

    public func startMovingPhase() throws {
        var hasToRemove: Bool = false
        print("All pieces have been placed, starting phase 2 - moving pieces")

        while gameState == GameState.movingPieces || hasToRemove {
            if !hasToRemove {
                print("\(currentPlayer.rawValue) please enter coordinates to move a piece:")
                let coordinates: (Int, Int) = try ioHandler.getDoubleCoordinates()

                do {
                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, index2: coordinates.1)
                    board.visualize()
                } catch BoardError.indexOutOfRange {
                    print("The coordinates for moving a piece are outside the board!")
                    print("Please try again.")
                    continue
                } catch BoardError.failedToMovePiece(let description) {
                    print(description)
                    print("Please try again.")
                    continue
                }
            }

            if hasToRemove {
                print("\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    print("\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                } catch BoardError.indexOutOfRange {
                    print("The coordinates for piece removal are outside the board!")
                    print("Please try again.")
                    continue
                } catch BoardError.failedToRemovePiece(let description) {
                    print(description)
                    print("Please try again.")
                    continue
                }

                hasToRemove = false
            }

            currentPlayer = nextPlayer
        }

        print(GameConstants.screenSeparator)
    }

    public func startFlyingPhase() throws {
        let playerLeftWith3Pieces = currentPlayerObject.placedPieces == 3 ? currentPlayer : nextPlayer
        print("\(playerLeftWith3Pieces.rawValue) you have 3 pieces left, starting phase 3 - flying")
        var hasToRemove: Bool = false;

        while gameState == GameState.flyingPieces || hasToRemove {
            if !hasToRemove {
                print("\(currentPlayer.rawValue) please enter coordinates to move a piece:")
                let coordinates: (Int, Int) = try ioHandler.getDoubleCoordinates()
                let adjacent: Bool = playerLeftWith3Pieces != currentPlayer

                do {
                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, 
                                                                    index2: coordinates.1, 
                                                                    adjacentOnly: adjacent)
                    board.visualize()
                } catch BoardError.indexOutOfRange {
                    print("The coordinates for moving a piece are outside the board!")
                    print("Please try again.")
                    continue
                } catch BoardError.failedToMovePiece(let description) {
                    print(description)
                    print("Please try again.")
                    continue
                }
            }

            if hasToRemove {
                print("\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                let coordinates = try ioHandler.getSingleCoordinates()

                do {
                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    print("\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                } catch BoardError.indexOutOfRange {
                    print("The coordinates for piece removal are outside the board!")
                    print("Please try again.")
                    continue
                } catch BoardError.failedToRemovePiece(let description) {
                    print(description)
                    print("Please try again.")
                    continue
                }

                hasToRemove = false
            }

            currentPlayer = nextPlayer
        }

        print(GameConstants.screenSeparator)
    }

    public func handleGameOver() throws {
        guard gameState == GameState.gameOver else {
            throw GameError.gameIsNotOver
        }

        let winner: PlayerType = player1.placedPieces > player2.placedPieces ? .player1 : .player2

        print(GameConstants.screenSeparator)
        print("Game is over!")
        print("Congratulations \(winner.rawValue) you are the winner!")
        print("Final game scores are: \(PlayerType.player1.rawValue) with score \(player1.placedPieces) ", terminator: "")
        print("and \(PlayerType.player2.rawValue) with score \(player2.placedPieces)!")
    }

    private func getPlayerObject(playerType: PlayerType) -> Player {
        return playerType == PlayerType.player1 ? player1 : player2
    }
}
