import Rainbow

// The output handler protocol which every class which handles the output
// visualization to the user should implement using this game package.
public protocol OutputHandler {

    // displays an output to the user in some way
    func display(output: String)

    // Displays an error output to the user in some way. It can be used
    // if the user has entered invalid input or for displaying any general
    // errors which had occurred
    func displayError(error: String)
}

// Console implementation of the output handler. Displays the output (regular and error)
// to the user in the standard output.
public class ConsoleOutputHandler: OutputHandler {

    // public empty initializer to make this class accessible in other modules
    public init() {}

    // displays an output to the user in the standard output
    public func display(output: String) {
        print(output)
    }

    // displays the error output to the user in the standard output
    public func displayError(error: String) {
        display(output: error)
    }
}

// Extends the consoleOutputHandler to add more specific visualization
// for the error output, using external library which adds color to
// the standard output. Link: https://github.com/onevcat/Rainbow
public class ConsoleOutputAndErrorHandler: ConsoleOutputHandler {

    // displays the error output to the user in red color in the standard output
    override public func displayError(error: String) {
        print(error.red)
    }
}