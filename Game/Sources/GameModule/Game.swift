import IOModule

// The game protocol with all 3 main phases of the game
public protocol Game {

    // the next player
    var nextPlayer: PlayerType { get }

    // the current game state
    var gameState: GameState { get }

    // starts the placing phase
    func startPlacingPhase() throws

    // starts the moving phase
    func startMovingPhase() throws

    // starts the flying phase
    func startFlyingPhase() throws

    // handles the game over
    func handleGameOverPhase() throws
}

// Console implementation of the nine-mens-morris game, specificed by the 
// Game interface. If the input entered by the user is invalid it is being 
// handled in the methods below and messages with information about the it 
// are being displayed to the user using the output handler.
public class ConsoleGame: Game {

    // the two players
    private var player1: Player
    private var player2: Player

    // the board
    private var board: Board
    
    // the player which has to move 
    private var currentPlayer: PlayerType

    // i/o handlers
    private var inputHandler: InputHandler
    private var outputHandler: OutputHandler

    // Initializes the console game and gets the input of the player's colors
    // If an error occurs while getting the user input about the colors, the error is 
    // propagated to the caller in this case the GameManager.
    public init(inputHandler: InputHandler, outputHandler: OutputHandler) throws {
        self.inputHandler = inputHandler
        self.outputHandler = outputHandler
        let colors: (PlayerColor, PlayerColor) = try inputHandler.getPlayerColors()

        board = Board(_size: Constants.boardSize, outputHandler: outputHandler)
        player1 = HumanPlayer(color: colors.0, board: board)
        player2 = HumanPlayer(color: colors.1, board: board)
        currentPlayer = PlayerType.player1

        // display user info about the game initialization
        outputHandler.display(output: Constants.gameStarted)
        outputHandler.display(output:
            "\(currentPlayer.rawValue) has the \(colors.0.rawValue) pieces, \(nextPlayer.rawValue) has the \(colors.1.rawValue) pieces")
        outputHandler.display(output:Constants.screenSeparator)
    }
}

// computable properties
extension ConsoleGame {

    // computes the next player based on the current player
    public var nextPlayer: PlayerType {
        get {
            if currentPlayer == PlayerType.player1 {
                return PlayerType.player2
            }

            return PlayerType.player1
        }
    }

    // computes the game state based on the player's pieces
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

    // Starts the piece placing phase of the game. In this phase both players have
    // to place their pieces on the board, by selecting non-assigned indices. If after 
    // piece placement a mill has been completed, the player who completed it gets to 
    // remove one of the opponent's pieces.
    public func startPlacingPhase() throws {
        var hasToRemove: Bool = false
        board.visualize()

        while gameState == GameState.placingPieces || hasToRemove {
            do {
                if !hasToRemove {
                    outputHandler.display(output:"\(currentPlayer.rawValue) please enter coordinates to place a piece:")
                    let coordinates = try inputHandler.getSingleCoordinates()
                    
                    hasToRemove = try currentPlayerObject.assignPiece(index: coordinates)
                    outputHandler.display(output:
                        "\(currentPlayer.rawValue), you have \(currentPlayerObject.piecesToPlace) pieces left to place")
                    board.visualize()
                }
                
                // if completed a mill and has to remove an opponent's piece
                if hasToRemove {
                    outputHandler.display(output: 
                        "\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                    let coordinates = try inputHandler.getSingleCoordinates()

                    try nextPlayerObject.removePiece(index: coordinates)

                    // visualization as this is an extra move
                    board.visualize() 
                    outputHandler.display(output: "\(nextPlayer.rawValue) you have \(nextPlayerObject.placedPieces) placed pieces left")
                    hasToRemove = false
                }

                currentPlayer = nextPlayer
            } catch BoardError.indexOutOfRange {
                    // this shouldn't happen if the ConsoleInputHandler implementation of the 
                    // InputHandler is used, but can happen with another one
                    outputHandler.display(output: Constants.invalidCoordinates)
                    outputHandler.display(output: Constants.tryAgain)
            // no multi-pattern matching supported, this is why we have 2 catches which share the same code
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

// phase 2
extension ConsoleGame {

    // Starts the moving phase of the game. In this phase both players have to move 
    // their pieces around the board, by selecting adjacent indices. If after moving 
    // the piece a mill has been completed, the player who completed it gets to remove 
    // one of the opponent's pieces.
    public func startMovingPhase() throws {
        var hasToRemove: Bool = false
        outputHandler.display(output: Constants.startingMovingPhase)

        while gameState == GameState.movingPieces || hasToRemove {
            do {
                if !hasToRemove {
                    outputHandler.display(output: "\(currentPlayer.rawValue) please enter coordinates to move a piece:")
                    let coordinates: (Int, Int) = try inputHandler.getDoubleCoordinates()
                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, index2: coordinates.1, adjacentOnly: true)
                    board.visualize()
                }

                // if completed a mill and has to remove an opponent's piece
                if hasToRemove {
                    outputHandler.display(output: 
                        "\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                    let coordinates = try inputHandler.getSingleCoordinates()

                    try nextPlayerObject.removePiece(index: coordinates)

                    // visualization as this is an extra move
                    board.visualize() 
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

    // Starts the flying phase of the game. In this phase the player with 3 pieces
    // can 'fly' on the board, by not having to select adjacent indices as opposed 
    // to the other player, who stil has to enter adjacent indices to move pieces on.
    public func startFlyingPhase() throws {
        let playerLeftWith3Pieces = currentPlayerObject.placedPieces == 3 ? currentPlayer : nextPlayer
        outputHandler.display(output: "\(playerLeftWith3Pieces.rawValue) you have 3 pieces left, starting phase 3 - flying")
        var hasToRemove: Bool = false;

        while gameState == GameState.flyingPieces || hasToRemove {
            do {
                if !hasToRemove {
                    outputHandler.display(output: "\(currentPlayer.rawValue) please enter coordinates to move a piece:")
                    let coordinates: (Int, Int) = try inputHandler.getDoubleCoordinates()
                    // is the current player the one with 3 pieces, if no then adjacent becomes true
                    let adjacent: Bool = playerLeftWith3Pieces != currentPlayer

                    hasToRemove = try currentPlayerObject.movePiece(index1: coordinates.0, 
                                                                    index2: coordinates.1, 
                                                                    adjacentOnly: adjacent)
                        board.visualize()
                }

                // if completed a mill and has to remove an opponent's piece
                if hasToRemove {
                    outputHandler.display(output: 
                        "\(currentPlayer.rawValue) you have formed a mill, please enter coordinates to remove one of your opponent's pieces:")
                    let coordinates = try inputHandler.getSingleCoordinates()

                    try nextPlayerObject.removePiece(index: coordinates)

                    // visualization as this is an extra move
                    board.visualize() 
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

// phase 4
extension ConsoleGame {

    // Function which handles the game over phase, by displaying the winner and 
    // the final scores. If the game is not in the GameState.gameOver state, 
    // GameError.gameIsNotOver is thrown, this should not happen with the current 
    // implementation.
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

    // gets the current player object
    private var currentPlayerObject: Player {
        return getPlayerObject(playerType: currentPlayer)
    }

    // gets the next player object
    private var nextPlayerObject: Player {
        return getPlayerObject(playerType: nextPlayer)
    }

    // function to return player object based on the type of the player
    private func getPlayerObject(playerType: PlayerType) -> Player {
        return playerType == PlayerType.player1 ? player1 : player2
    }
}