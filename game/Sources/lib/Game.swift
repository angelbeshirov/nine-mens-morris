// class declaration
public protocol Game {
    var nextPlayer: PlayerType { get }
    var gameState: GameState { get }

    func startPlacingPhase() throws
    func startMovingPhase() throws
    func startFlyingPhase() throws
    func handleGameOverPhase() throws
}

public class ConsoleGame: Game {
    private var player1: Player
    private var player2: Player
    private var board: Board
    
    private var currentPlayer: PlayerType
    private var inputHandler: InputHandler
    private var outputHandler: OutputHandler

    public init(inputHandler: InputHandler, outputHandler: OutputHandler) throws {
        self.inputHandler = inputHandler
        self.outputHandler = outputHandler
        let colors: (PlayerColor, PlayerColor) = try inputHandler.getPlayerColors()

        board = Board(_size: Constants.boardSize, outputHandler: outputHandler)
        player1 = Player(color: colors.0, board: board)
        player2 = Player(color: colors.1, board: board)
        currentPlayer = PlayerType.player1
        outputHandler.display(output: Constants.gameStarted)
        outputHandler.display(output:
            "\(currentPlayer.rawValue) has \(colors.0.rawValue) pieces, \(nextPlayer.rawValue) has \(colors.1.rawValue) pieces")
        outputHandler.display(output:Constants.screenSeparator)
    }
}

// computable properties
extension ConsoleGame {
    public var nextPlayer: PlayerType {
        get {
            if currentPlayer == PlayerType.player1 {
                return PlayerType.player2
            }

            return PlayerType.player1
        }
    }

    public var gameState: GameState {
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
}

// phase 1
extension ConsoleGame {
    public func startPlacingPhase() throws {
        var hasToRemove: Bool = false
        board.visualize()

        while gameState == GameState.placingPieces || hasToRemove {
            do {
                if !hasToRemove {
                    outputHandler.display(output:"\(currentPlayer.rawValue) please enter coordinates to place a piece:")
                    let coordinates = try inputHandler.getSingleCoordinates()
                    
                    hasToRemove = try currentPlayerObject.assign(index: coordinates)
                    outputHandler.display(output:
                        "\(currentPlayer.rawValue), you have \(currentPlayerObject.piecesToPlace) pieces left to place")
                    board.visualize()
                }

                if hasToRemove {
                    outputHandler.display(output: 
                        "\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                    let coordinates = try inputHandler.getSingleCoordinates()

                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    outputHandler.display(output: "\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                    hasToRemove = false
                }

                currentPlayer = nextPlayer
            } catch BoardError.indexOutOfRange {
                    // this shouldn't happen if the ConsoleInputHandler implementation of the InputHandler is used, but can happen with another one
                    outputHandler.display(output: Constants.invalidCoordinates)
                    outputHandler.display(output: Constants.tryAgain)
            } catch BoardError.failedToAssignPiece(let description) { // no multi-pattern matching supported, this is why we have 2 catches which are the same
                    outputHandler.display(output: description)
                    outputHandler.display(output: Constants.tryAgain)
            } catch BoardError.failedToRemovePiece(let description) {
                    outputHandler.display(output: description)
                    outputHandler.display(output: Constants.tryAgain)
            }
        }

        outputHandler.display(output: Constants.screenSeparator)
    }
}

// phase 2
extension ConsoleGame {
    public func startMovingPhase() throws {
        var hasToRemove: Bool = false
        outputHandler.display(output: Constants.startingMovingPhase)

        while gameState == GameState.movingPieces || hasToRemove {
            do {
                if !hasToRemove {
                    outputHandler.display(output: "\(currentPlayer.rawValue) please enter coordinates to move a piece:")
                    let coordinates: (Int, Int) = try inputHandler.getDoubleCoordinates()
                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, index2: coordinates.1)
                    board.visualize()
                }

                if hasToRemove {
                    outputHandler.display(output: 
                        "\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                    let coordinates = try inputHandler.getSingleCoordinates()

                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    outputHandler.display(output: "\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")

                    hasToRemove = false
                }

                currentPlayer = nextPlayer
            } catch BoardError.indexOutOfRange {
                    outputHandler.display(output: Constants.invalidCoordinates)
                    outputHandler.display(output: Constants.tryAgain)
            } catch BoardError.failedToMovePiece(let description) {
                    outputHandler.display(output: description)
                    outputHandler.display(output: Constants.tryAgain)
            } catch BoardError.failedToRemovePiece(let description) {
                    outputHandler.display(output: description)
                    outputHandler.display(output: Constants.tryAgain)
            }
        }

        outputHandler.display(output: Constants.screenSeparator)
    }
}

// phase 3
extension ConsoleGame {
    public func startFlyingPhase() throws {
        let playerLeftWith3Pieces = currentPlayerObject.placedPieces == 3 ? currentPlayer : nextPlayer
        outputHandler.display(output: "\(playerLeftWith3Pieces.rawValue) you have 3 pieces left, starting phase 3 - flying")
        var hasToRemove: Bool = false;

        while gameState == GameState.flyingPieces || hasToRemove {
            do {
                if !hasToRemove {
                    outputHandler.display(output: "\(currentPlayer.rawValue) please enter coordinates to move a piece:")
                    let coordinates: (Int, Int) = try inputHandler.getDoubleCoordinates()
                    let adjacent: Bool = playerLeftWith3Pieces != currentPlayer

                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, 
                                                                    index2: coordinates.1, 
                                                                    adjacentOnly: adjacent)
                        board.visualize()
                }

                if hasToRemove {
                    outputHandler.display(output: 
                        "\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                    let coordinates = try inputHandler.getSingleCoordinates()

                    try nextPlayerObject.removePiece(index: coordinates)
                    board.visualize() // visualization as this is an extra move
                    outputHandler.display(output: "\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")

                    hasToRemove = false
                }

                currentPlayer = nextPlayer
            } catch BoardError.indexOutOfRange {
                outputHandler.display(output: Constants.invalidCoordinates)
                outputHandler.display(output: Constants.tryAgain)
            } catch BoardError.failedToAssignPiece(let description) {
                outputHandler.display(output: description)
                outputHandler.display(output: Constants.tryAgain)
            } catch BoardError.failedToRemovePiece(let description) {
                outputHandler.display(output: description)
                outputHandler.display(output: Constants.tryAgain)
            }
        }

        outputHandler.display(output: Constants.screenSeparator)
    }
}

// phase 4
extension ConsoleGame {
    public func handleGameOverPhase() throws {
        guard gameState == GameState.gameOver else {
            throw GameError.gameIsNotOver
        }

        let winner: PlayerType = player1.placedPieces > player2.placedPieces ? .player1 : .player2

        outputHandler.display(output: Constants.screenSeparator)
        outputHandler.display(output: Constants.gameOver)
        outputHandler.display(output: "Congratulations \(winner.rawValue) you are the winner!")
        outputHandler.display(output: 
            "Final game scores are: \(PlayerType.player1.rawValue) with score \(player1.placedPieces) ")
        outputHandler.display(output: "and \(PlayerType.player2.rawValue) with score \(player2.placedPieces)!")
    }
}

// private helpers
extension ConsoleGame {
    private var currentPlayerObject: Player {
        return getPlayerObject(playerType: currentPlayer)
    }

    private var nextPlayerObject: Player {
        return getPlayerObject(playerType: nextPlayer)
    }

    private func getPlayerObject(playerType: PlayerType) -> Player {
        return playerType == PlayerType.player1 ? player1 : player2
    }
}
