// The output handler protocol which every class handling the output to
// the user should implement using the current game package.
public protocol OutputHandler {

    // displays the output to the user in some way
    func display(output: String)
}

// Console implementation of the output handler. Displays the output to the user in 
// the console where the game is started.
public class ConsoleOutputHandler: OutputHandler {

    // public empty initializer to make this class accessible in other modules
    public init() {}

    // displays the output to the user in the console
    public func display(output: String) {
        print(output)
    }
}