import GameModule
import Rainbow

/// This is the starting point of the application, here
/// we define a GameManager and choose a game type to start.
/// This is an example of console game without GUI, but it can be
/// extended later on.

// print("Red text".black)
// print("Blue background".onBlue)
// print("Light green text on white background".lightGreen.onWhite)

// let s1 = "Red text".red
// print(s1)
// print("Underline".dim)
// print("Cyan with bold and blinking".cyan.bold.blink)

// print("Plain text".red.onYellow.bold.clearColor.clearBackgroundColor.clearStyles)
let gameManager = GameManager()
gameManager.startConsoleGame()
